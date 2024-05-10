# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "${local.base_source_url}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  account_name = local.account_vars.locals.account_name
  env          = local.environment_vars.locals.env
  region       = local.region_vars.locals.region
  region_tag   = local.region_vars.locals.region_tag

  cluster_name = "eks-${local.env}-${local.region_tag[local.region]}"

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "../../..//modules/eks-workers" # relative path from execution dir
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../vpc", "../eks-control-plane", "../eks-workers-ebs-encryption"]
}

dependency "vpc" {
  config_path = "../vpc"

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    vpc_id          = "vpc-"
    private_subnets = ["subnet1", "subnet2", "subnet3", "subnet4"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs
}

dependency "eks" {
  config_path = "../eks-control-plane"

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    cluster_version                    = "1.28"
    cluster_endpoint                   = "dummy"
    cluster_certificate_authority_data = "dummy"
    cluster_primary_security_group_id  = "sg-"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs
}

dependency "eks-workers-ebs-encryption" {
  config_path = "../eks-workers-ebs-encryption"

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    kms_key_arn = "dummy"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  # dependencies
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  cluster_version                    = dependency.eks.outputs.cluster_version
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_primary_security_group_id  = dependency.eks.outputs.cluster_primary_security_group_id

  cluster_name = local.cluster_name
  region       = local.region
  region_tag   = local.region_tag
  env          = local.env

  # ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L66-L72
  self_managed_node_group_defaults = {
    # enable discovery of autoscaling groups by cluster-autoscaler: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md
    # NOTE: can't use resource "aws_autoscaling_group_tag" to edit tags at runtime like this example (https://github.com/particuleio/teks/blob/main/terragrunt/snippets/eks-asg-tags/eks-asg-tags.tf#L91-L103), since self-managed-node-group is adding tags in resource "autoscaling_group". Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned",
    }
  }
  self_managed_node_groups = {
    "m1.small" = {
      name          = "${local.env}-m1small"
      instance_type = "m1.small" # since we are using AWS-VPC-CNI, allocatable pod IPs are defined by instance size: https://docs.google.com/spreadsheets/d/1MCdsmN7fWbebscGizcK6dAaPGS-8T_dYxWp0IdwkMKI/edit#gid=1549051942, https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
      max_size      = 1
      desired_size  = 1 # this will be ignored if cluster autoscaler is enabled: asg_desired_capacity: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md#notes

      user_data_template_path  = "templates/linux_user_data.tpl"
      post_bootstrap_user_data = <<-EOT
      # this is to completely block all containers running on a worker node from querying the instance metadata service for any metadata to avoid pods from using node's IAM instance profile
      # ref: https://docs.aws.amazon.com/eks/latest/userguide/restrict-ec2-credential-access.html
      yum install -y iptables-services; iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP; iptables-save | tee /etc/sysconfig/iptables; systemctl enable --now iptables;

      # install Inspector agent
      curl -O https://inspector-agent.amazonaws.com/linux/latest/install; sudo bash install;

      # install SSM agent
      sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm; sudo systemctl enable amazon-ssm-agent; sudo systemctl start amazon-ssm-agent;

      EOT
      bootstrap_extra_args     = "--kubelet-extra-args '--node-labels=env=${local.env},self-managed-node=true,region=${local.region},k8s_namespace=${local.env}  --register-with-taints=${local.env}-only=true:PreferNoSchedule'" # for self-managed nodes, taints and labels work only with extra-arg, not ASG tags. Ref: https://aws.amazon.com/blogs/opensource/improvements-eks-worker-node-provisioning/

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            encrypted             = true
            kms_key_id            = dependency.eks-workers-ebs-encryption.outputs.cluster_workers_ebs_kms_arn
            delete_on_termination = true
          }
        }
      }

      tags = {
        "self-managed-node" = true
        "k8s_namespace"     = local.env
      }
    },
  }
}
