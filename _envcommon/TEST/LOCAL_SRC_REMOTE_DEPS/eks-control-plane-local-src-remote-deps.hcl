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
  account_name = local.account_vars.locals.account_name
  env          = local.environment_vars.locals.env
  region       = local.region_vars.locals.region
  region_tag   = local.region_vars.locals.region_tag

  env_region_metadata = "${local.env}-${local.region_tag[local.region]}"
  suffix              = "local-src-remote-deps"

  cluster_name    = "eks-${local.env_region_metadata}-${local.account_name}-${local.suffix}" # use "expose = true" in child config to expose this
  cluster_version = 1.29
  instance_type   = "c1.medium"

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR LOCAL SOURCE using local resource{} not remote module{}
  ###################
  base_source_url = "../../..//modules/eks-control-plane" # relative path from execution dir
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../vpc-remote-source", "../eks-control-plane-logs-local-src-remote-deps", "../iam-roles-remote-source"]
}

dependency "vpc" {
  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../DEP_DIR_NAME"" in the parent config, IF there is dependency {} in parent, that'll mess up path.
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("DEP_DIR_NAME")" or 2) comment out "expose = true"
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/_envcommon/TEST/vpc-remote-source: open /terragrunt-eks-vpc/_envcommon/TEST/vpc-remote-source: no such file or directory 
  # ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
  # config_path = "../vpc-remote-source" # this will try to find in the path "terragrunt-eks-vpc/_envcommon/TEST/vpc-remote-source"

  # WARNING2: if parent's terragrunt.hcl is not on the same path as dependent module "vpc-remote-source", you will get below error 
  # ERRO[0000] /terragrunt-eks-vpc/_envcommon/TEST/LOCAL_SRC_REMOTE_DEPS/eks-control-plane-local-src-remote-deps.hcl:56,17-40: Error in function call; Call to function "find_in_parent_folders" failed: ParentFileNotFound: Could not find a ../vpc-remote-source in any of the parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl. Cause: Traversed all the way to the root.., and 1 other diagnostic(s) 
  # WORKAROUND: 1) comment out "expose = true", or 2) use "config_path = find_in_parent_folders("DEP_DIR_NAME")"
  # this will try to find in parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl
  config_path = find_in_parent_folders("vpc-remote-source") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    vpc_id          = "vpc-"
    private_subnets = ["subnet1", "subnet2", "subnet3", "subnet4"]
    azs             = ["az1a", "az1b", "az1c", "az1d"]
  }

  mock_outputs_merge_strategy_with_state = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  # WARNING: for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true". Some reasons could be: 1) the dependent module hasn't been applied yet, 2) output not defined in outputs.tf, 3) or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
  # error "/terragrunt-eks-vpc/ue1/dev/aws-data/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block."
  mock_outputs_allowed_terraform_commands = ["plan", "validate"] # this means for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true", and might return "Unsupported attribute; This object does not have an attribute named "cloudwatch_log_group_arn". Some reasons could be: 1) output not defined in outputs.tf, or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
}

dependency "eks-control-plane-logs" {
  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../DEP_DIR_NAME"" in the parent config, IF there is dependency {} in parent, that'll mess up path.
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("DEP_DIR_NAME")" or 2) comment out "expose = true"
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/_envcommon/TEST/eks-control-plane-logs-local-src-remote-deps: open /terragrunt-eks-vpc/_envcommon/TEST/eks-control-plane-logs-local-src-remote-deps: no such file or directory 
  # config_path = "../eks-control-plane-logs-local-src-remote-deps" # this will try to find in the path "terragrunt-eks-vpc/_envcommon/TEST/iam-roles-remote-source"

  # WARNING2: if parent's terragrunt.hcl is not on the same path as dependent module "DEP_DIR_NAME", you will get below error 
  # ERRO[0000] /terragrunt-eks-vpc/_envcommon/TEST/LOCAL_SRC_REMOTE_DEPS/eks-control-plane-local-src-remote-deps.hcl:56,17-40: Error in function call; Call to function "find_in_parent_folders" failed: ParentFileNotFound: Could not find a ../vpc-remote-source in any of the parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl. Cause: Traversed all the way to the root.., and 1 other diagnostic(s) 
  # WORKAROUND: 1) comment out "expose = true", or 2) use "config_path = find_in_parent_folders("DEP_DIR_NAME")"
  # this will try to find in parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl
  config_path = find_in_parent_folders("eks-control-plane-logs-local-src-remote-deps") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342


  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    cloudwatch_log_group_arn = "dummy"
  }

  mock_outputs_merge_strategy_with_state = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  # WARNING: for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true". Some reasons could be: 1) the dependent module hasn't been applied yet, 2) output not defined in outputs.tf, 3) or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
  mock_outputs_allowed_terraform_commands = ["plan", "validate"] # this means for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true", and might return "Unsupported attribute; This object does not have an attribute named "cloudwatch_log_group_arn". Some reasons could be: 1) output not defined in outputs.tf, or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
}

dependency "iam-roles-remote-source" {
  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../DEP_DIR_NAME"" in the parent config, IF there is dependency {} in parent, that'll mess up path.
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("DEP_DIR_NAME")" or 2) comment out "expose = true"
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/_envcommon/TEST/iam-roles-remote-source: open /terragrunt-eks-vpc/_envcommon/TEST/iam-roles-remote-source: no such file or directory 
  # config_path = "../iam-roles-remote-source" # this will try to find in the path "/terragrunt-eks-vpc/_envcommon/TEST/iam-roles-remote-source"

  # WARNING2: if parent's terragrunt.hcl is not on the same path as dependent module "DEP_DIR_NAME", you will get below error 
  # ERRO[0000] /terragrunt-eks-vpc/_envcommon/TEST/LOCAL_SRC_REMOTE_DEPS/eks-control-plane-local-src-remote-deps.hcl:56,17-40: Error in function call; Call to function "find_in_parent_folders" failed: ParentFileNotFound: Could not find a ../vpc-remote-source in any of the parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl. Cause: Traversed all the way to the root.., and 1 other diagnostic(s) 
  # WORKAROUND: 1) comment out "expose = true", or 2) use "config_path = find_in_parent_folders("DEP_DIR_NAME")"
  # this will try to find in parent folders of /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps/terragrunt.hcl
  config_path = find_in_parent_folders("iam-roles-remote-source") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    poweruser_iam_role_arn = "dummy"
  }

  mock_outputs_merge_strategy_with_state = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  # WARNING: for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true". Some reasons could be: 1) the dependent module hasn't been applied yet, 2) output not defined in outputs.tf, 3) or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
  mock_outputs_allowed_terraform_commands = ["plan", "validate"] # this means for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = true", and might return "Unsupported attribute; This object does not have an attribute named "cloudwatch_log_group_arn". Some reasons could be: 1) output not defined in outputs.tf, or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  ###################
  # FOR LOCAL SOURCE using local resource{} not remote module{}
  # base_source_url = "../../..//modules/eks-control-plane"
  ###################

  cluster_name = local.cluster_name
  region       = local.region
  region_tag   = local.region_vars.locals.region_tag
  env          = local.env

  # note: if dependent module "vpc" hasn't been deployed, "terragrunt plan" will error out "Either the target module has not been applied yet, or the module has no outputs"
  # ref: "If module A depends on module B and module B hasn’t been applied yet, then run-all plan will show the plan for B, but exit with an error when trying to show the plan for A"
  # ref: https://github.com/gruntwork-io/terragrunt/issues/1330#issuecomment-1589092127
  vpc_id                      = dependency.vpc.outputs.vpc_id
  private_subnets             = dependency.vpc.outputs.private_subnets
  azs                         = dependency.vpc.outputs.azs
  cluster_cloudwatch_logs_arn = dependency.eks-control-plane-logs.outputs.cloudwatch_log_group_arn

  create_eks                     = true
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true # need this otherwise can't access EKS from outside VPC. Ref: https://github.com/terraform-aws-modules/terraform-aws-eks#input_cluster_endpoint_public_access
  enabled_cluster_log_types      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # AWS auth
  # REF: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/aws-auth/README.md
  manage_aws_auth_configmap = true
  create_aws_auth_configmap = true # for self-managed nodes, needs to be set true
  aws_auth_roles = [
    {
      rolearn  = dependency.iam-roles-remote-source.outputs.poweruser_iam_role_arn # TODO: dependency
      username = "k8s-admin"
      groups   = ["system:masters"]
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
        host                   = aws_eks_cluster.this.cluster_endpoint
        cluster_ca_certificate = base64decode(aws_eks_cluster.this.cluster_certificate_authority_data)
        exec {
           api_version = "client.authentication.k8s.io/v1beta1"
           command     = "aws"
           # This requires the awscli to be installed locally where Terraform is executed
           args = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
      }
    }
EOF
}