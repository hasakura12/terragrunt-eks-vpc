# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = local.base_source_url
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
  account_name        = local.account_vars.locals.account_name
  aws_account_id      = local.account_vars.locals.aws_account_id
  admin_role_name     = local.account_vars.locals.admin_role_name
  terraform_role_name = local.account_vars.locals.terraform_role_name
  env                 = local.environment_vars.locals.env
  region              = local.region_vars.locals.region
  region_tag          = local.region_vars.locals.region_tag

  env_region_metadata = "${local.env}-${local.region_tag[local.region]}"
  suffix              = "local-src-remote-mod-deps"

  cluster_name    = "eks-${local.env_region_metadata}-${local.account_name}-${local.suffix}" # use "expose = true" in child config to expose this
  cluster_version = 1.29
  instance_type   = "c1.medium"

  kms_key_name = "cmk-${local.env_region_metadata}-${local.account_name}-${local.suffix}"

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR LOCAL SOURCE which is in turn using REMOTE MODULE
  ###################
  base_source_url = "../../..//modules/container/eks" # relative path from execution dir
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../vpc-remote-source", "../iam-roles-remote-source"]
}

dependency "vpc" {
  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../DEP_DIR_NAME"" in the parent config, IF there is dependency {} in parent, that'll mess up path.
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("DEP_DIR_NAME")" or 2) comment out "expose = true"
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/_envcommon/TEST/vpc-remote-source: open /terragrunt-eks-vpc/_envcommon/TEST/vpc-remote-source: no such file or directory 
  # config_path = "../vpc-remote-source"

  # WARNING2: if this module's parent terragrunt.hcl is not on the same path as dependent module "vpc-remote-source", you will get below error 
  # WORKAROUND: 1) comment out "expose = true", or 2) use "config_path = find_in_parent_folders("DEP_DIR_NAME")"
  # ERRO[0000] /terragrunt-eks-vpc/_envcommon/TEST/LOCAL_SRC_REMOTE_DEPS/eks-control-plane-local-src-remote-deps.hcl:56,17-40: Error in function call; Call to function "find_in_parent_folders" failed: ParentFileNotFound: Could not find a ../vpc-remote-source in any of the parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl. Cause: Traversed all the way to the root.., and 1 other diagnostic(s) 
  config_path = find_in_parent_folders("vpc-remote-source") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    vpc_id          = "vpc-"
    public_subnets  = ["subnet1", "subnet2", "subnet3", "subnet4"]
    private_subnets = ["subnet1", "subnet2", "subnet3", "subnet4"]
    azs             = ["az1a", "az1b", "az1c", "az1d"]
  }

  mock_outputs_merge_strategy_with_state = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  # WARNING1: # for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = shallow", and might cause "Unsupported attribute; This object does not have an attribute named "cloudwatch_log_group_arn". Some reasons could be: 1) the dependent module hasn't been applied yet, 2) output not defined in outputs.tf, 3) or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
  # WARNING2: if not "terragrunt apply" yet, you will get a misleading error (actually just warning if run "terragrunt run-all apply" or go to the dep module and "terragrunt apply") "/terragrunt-eks-vpc/ue1/dev/aws-data/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block."
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "iam-roles-remote-source" {
  config_path = find_in_parent_folders("iam-roles-remote-source") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # TESTS
  # config_path = find_in_parent_folders("iam-roles")
  # config_path = "${get_terragrunt_dir()}/../iam-roles" # /terraform/_envcommon/eks.hcl:268,28-38: Unsupported attribute; This object does not have an attribute named "iam_roles"., and 1 other diagnostic(s) 
  # config_path = "${get_parent_terragrunt_dir("root")}/iam-roles" # /terraform/_envcommon/iam-roles: no such file or directory 
  # config_path = "${get_parent_terragrunt_dir("root")}/../iam-roles" # /terraform/iam-roles: no such file or directory 
  # config_path = "${get_parent_terragrunt_dir("root")}/../ue1/dev/iam-roles" # /terraform/_envcommon/eks.hcl:266,28-38: Unsupported attribute; This object does not have an attribute named "iam_roles"., and 1 other diagnostic(s)

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    poweruser_iam_role_arn = "dummy"
  }

  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  ###################
  # FOR LOCAL SOURCE which is in turn using REMOTE MODULE
  # base_source_url = "../../..//modules/container/eks"
  # REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L27
  ###################
  cluster_name                   = local.cluster_name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # note: if dependent module "vpc" hasn't been deployed, "terragrunt plan" will error out "Either the target module has not been applied yet, or the module has no outputs"
  # ref: "If module A depends on module B and module B hasn’t been applied yet, then run-all plan will show the plan for B, but exit with an error when trying to show the plan for A"
  # ref: https://github.com/gruntwork-io/terragrunt/issues/1330#issuecomment-1589092127
  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids = dependency.vpc.outputs.public_subnets

  # NOTE: move these to module as TG inputs {} can't call module.
  # External encryption key
  # create_kms_key = false
  # cluster_encryption_config = {
  #   resources        = ["secrets"]
  #   provider_key_arn = module.kms_cluster.key_arn # TODO: dependency
  # }

  self_managed_node_group_defaults = {
    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned",
    }
  }

  self_managed_node_groups = {
    # Default node group - as provisioned by the module defaults
    default_node_group = {
      name            = "self-managed-worker-group-${local.env}-c1medium"
      use_name_prefix = false

      subnet_ids = dependency.vpc.outputs.private_subnets

      min_size     = 1
      max_size     = 1
      desired_size = 1

      # ami_id = data.aws_ami.eks_default.id

      pre_bootstrap_user_data = <<-EOT
          export FOO=bar
        EOT

      post_bootstrap_user_data = <<-EOT
        # this is to completely block all containers running on a worker node from querying the instance metadata service for any metadata to avoid pods from using node's IAM instance profile
        # ref: https://docs.aws.amazon.com/eks/latest/userguide/restrict-ec2-credential-access.html
        yum install -y iptables-services; iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP; iptables-save | tee /etc/sysconfig/iptables; systemctl enable --now iptables;

        # install Inspector agent
        curl -O https://inspector-agent.amazonaws.com/linux/latest/install; sudo bash install;

        # install SSM agent
        sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm; sudo systemctl enable amazon-ssm-agent; sudo systemctl start amazon-ssm-agent;

        EOT

      instance_type            = local.instance_type
      iam_role_use_name_prefix = false

      # block_device_mappings = {
      #   xvda = {
      #     device_name = "/dev/xvda"
      #     ebs = {
      #       volume_size           = 10
      #       volume_type           = "gp3"
      #       encrypted             = true
      #       kms_key_id            = module.kms_ebs.key_id # TODO: dependency
      #       delete_on_termination = true
      #     }
      #   }
      # }

      instance_attributes = {
        name = "instance-attributes"

        min_size     = 1
        max_size     = 1
        desired_size = 1

        bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot,env=${local.env},self-managed-node=true,region=${local.region} --register-with-taints=${local.env}-only=true:PreferNoSchedule'"
      }

      create_iam_role          = true
      iam_role_name            = "self-managed-node-group-complete-example"
      iam_role_use_name_prefix = false
      iam_role_description     = "Self managed node group complete example role"
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
    }
  }

  # Logs
  cloudwatch_log_group_retention_in_days = 7                                                                   # default is 90
  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"] # default is ["audit", "api", "authenticator"]

  # Extend node-to-node security group rules. Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L78
  # WARNING: need this for metrics-server to work, asn well as istio ingress/egress's readiness to work at http://:15021/healthz/ready. Ref: https://github.com/kubernetes-sigs/metrics-server/issues/1024#issuecomment-1124870217
  node_security_group_additional_rules = {
    # ingress_self_all = {
    #   description = "Node to node all ports/protocols"
    #   protocol    = "-1"
    #   from_port   = 0
    #   to_port     = 0
    #   type        = "ingress"
    #   self        = true
    # },
    # egress_all = {
    #   description = "Node all egress" # WARNING: need this for egress to DB ports
    #   protocol    = "-1"
    #   from_port   = 0
    #   to_port     = 0
    #   type        = "egress"
    #   cidr_blocks = ["0.0.0.0/0"]
    # },
    ingress_cluster_api_ephemeral_ports_tcp = {
      description                   = "Cluster API to K8S services running on nodes"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    },
  }

  # WARNING: needs this to allow kubeseal to work. Ref: https://github.com/bitnami-labs/sealed-secrets/issues/699#issuecomment-1064424553
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  ###################
  # FOR LOCAL module which is using remote source
  # KMS for EBS
  ###################
  # KMS for EBS encryption and K8s cluster
  kms_key_name = local.kms_key_name

  ###################
  # FOR LOCAL SOURCE which is in turn using REMOTE MODULE
  # AWS auth
  # REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/aws-auth/README.md
  ###################
  manage_aws_auth_configmap = true
  create_aws_auth_configmap = true # for self-managed nodes, needs to be set true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${local.aws_account_id}:role/${local.admin_role_name}"
      username = "k8s-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${local.aws_account_id}:role/${local.terraform_role_name}"
      username = "k8s-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = dependency.iam-roles-remote-source.outputs.poweruser_iam_role_arn # TODO: dependency
      username = "k8s-read-only"
      groups   = ["viewer"]
    },
  ]
}

# this needs to be generated, otherwise will get "Error: Post "http://localhost/api/v1/namespaces/kube-system/configmaps": dial tcp 127.0.0.1:80: connect: connection refused" because without k8s provider config, it'll default to connecting to localhost cluster
# ref: https://github.com/gruntwork-io/terragrunt/issues/1822
generate "provider-k8s-local" {
  path      = "provider-k8s-local.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "kubernetes" {
        host                   = module.eks.cluster_endpoint
        cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
        exec {
           api_version = "client.authentication.k8s.io/v1beta1"
           command     = "aws"
           # This requires the awscli to be installed locally where Terraform is executed
           args = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
      }
    }
EOF
}