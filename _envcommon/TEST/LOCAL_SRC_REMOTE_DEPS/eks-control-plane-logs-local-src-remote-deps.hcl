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

  env_region_metadata = "${local.env}-${local.region_tag[local.region]}"
  suffix              = "local-src-remote-deps"
  cluster_name        = "eks-${local.env_region_metadata}-${local.account_name}-${local.suffix}" # use "expose = true" in child config to expose this

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR LOCAL SOURCE
  ###################
  # base_source_url = "../../..//modules/eks-control-plane-logs" # relative path from execution dir

  ###################
  # FOR REMOTE SOURCE
  # source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  ###################
  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-cloudwatch.git//modules/log-group"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  ###################
  # FOR LOCAL SOURCE
  # base_source_url = "../../..//modules/eks-control-plane-logs"
  ###################
  # region     = local.region
  # region_tag = local.region_tag
  # env        = local.env

  # cluster_name                  = local.cluster_name
  # cluster_log_retention_in_days = 7


  ###################
  # FOR REMOTE SOURCE
  # REF: https://github.com/terraform-aws-modules/terraform-aws-cloudwatch/blob/master/examples/log-group-with-log-stream/main.tf#L5
  # base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-cloudwatch.git//modules/log-group"
  ###################
  name              = local.cluster_name
  retention_in_days = 7
}