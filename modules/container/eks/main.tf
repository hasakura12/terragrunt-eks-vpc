data "aws_caller_identity" "current" {}

locals {
  instance_types = [var.instance_type]

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 10
        volume_type           = "gp3"
        encrypted             = true
        kms_key_id            = module.kms_ebs.key_arn # this is circular dependency (i.e. this requires KMS to be created first, but KMS requires EKS cluster IAM role ARN), hence can't be defined in terragrunt.hcl as it can't access module.eks. Ideally, separate EKS control plane and EKS workers, and create EKS control plane, KMS, workers (where this block_device_mappings will be defined) in that order 
        delete_on_termination = true
      }
    }
  }

  appended_self_managed_node_group_list = [
    for self_managed_node_group in var.self_managed_node_groups :
    merge(
      self_managed_node_group,
      {
        "block_device_mappings" = local.block_device_mappings
      }
    )
  ]

  final_self_managed_node_groups = zipmap(local.instance_types, local.appended_self_managed_node_group_list)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws" # "git::git@github.com:terraform-aws-modules/terraform-aws-eks.git"
  version = "~> 20.10.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  cluster_addons = var.cluster_addons

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  self_managed_node_group_defaults = var.self_managed_node_group_defaults
  self_managed_node_groups         = local.final_self_managed_node_groups

  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cluster_enabled_log_types              = var.cluster_enabled_log_types

  node_security_group_additional_rules    = var.node_security_group_additional_rules
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  iam_role_use_name_prefix = var.iam_role_use_name_prefix

  ###################
  # FOR LOCAL module which is using remote source
  # KMS for EBS
  ###################
  # External encryption key
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms_cluster.key_arn # TODO: dependency
  }
}

# REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L378
module "kms_ebs" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1"

  description = "Customer managed key to encrypt EKS managed node group volumes"

  # Policy
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn, # TODO: dependency
  ]

  # Aliases
  aliases = ["eks/${var.kms_key_name}/ebs"]
}

# REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L402
module "kms_cluster" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1"

  aliases               = ["eks/${var.kms_key_name}"]
  description           = "KMS for cluster encryption key"
  enable_default_policy = true
  key_owners            = [data.aws_caller_identity.current.arn]
}

# REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/aws-auth/README.md
module "aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  create_aws_auth_configmap = var.create_aws_auth_configmap
  aws_auth_roles            = var.aws_auth_roles
}
