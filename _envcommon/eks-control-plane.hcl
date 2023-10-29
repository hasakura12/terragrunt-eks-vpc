# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "${local.base_source_url}"

  # refs: https://terragrunt.gruntwork.io/docs/features/hooks/#before-and-after-hooks, https://github.com/particuleio/teks/blob/main/terragrunt/live/production/eu-west-1/clusters/demo/eks/terragrunt.hcl#L31
  # after_hook "kubeconfig" {
  #   commands = ["apply"]
  #   execute  = ["bash", "-c", "aws eks update-kubeconfig --name ${include.root.locals.full_name} --kubeconfig ${get_terragrunt_dir()}/kubeconfig 2>/dev/null"]
  # }
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

  cluster_name = "eks-${local.env}-${local.region_tag[local.region]}" # use "expose = true" in child config to expose this

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "../../..//modules/eks-control-plane" # relative path from execution dir
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../vpc", "../eks-control-plane-logs"]
}

dependency "vpc" {
  config_path = "../vpc"

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    vpc_id          = "vpc-"
    private_subnets = ["subnet1", "subnet2", "subnet3", "subnet4"]
    azs             = ["az1a", "az1b", "az1c", "az1d"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs
}

dependency "eks-control-plane-logs" {
  config_path = "../eks-control-plane-logs"

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    cluster_cloudwatch_logs_arn = "dummy"
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
  cluster_name = "eks-${local.env}-${local.region_tag[local.region]}"
  region       = local.region
  region_tag   = local.region_vars.locals.region_tag
  env          = local.env

  # note: if dependent module "vpc" hasn't been deployed, "terragrunt plan" will error out "Either the target module has not been applied yet, or the module has no outputs"
  # ref: "If module A depends on module B and module B hasn’t been applied yet, then run-all plan will show the plan for B, but exit with an error when trying to show the plan for A"
  # ref: https://github.com/gruntwork-io/terragrunt/issues/1330#issuecomment-1589092127
  vpc_id                      = dependency.vpc.outputs.vpc_id
  private_subnets             = dependency.vpc.outputs.private_subnets
  azs                         = dependency.vpc.outputs.azs
  cluster_cloudwatch_logs_arn = dependency.eks-control-plane-logs.outputs.cluster_cloudwatch_logs_arn

  create_eks                     = true
  cluster_version                = 1.28
  cluster_endpoint_public_access = true # need this otherwise can't access EKS from outside VPC. Ref: https://github.com/terraform-aws-modules/terraform-aws-eks#input_cluster_endpoint_public_access
  enabled_cluster_log_types      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
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