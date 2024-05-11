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
  suffix              = "local-src-deps"

  cluster_name = "eks-${local.env_region_metadata}-${local.account_name}-${local.suffix}" # use "expose = true" in child config to expose this

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR LOCAL SOURCE
  ###################
  base_source_url = "../../..//modules/vpc" # relative path from execution dir
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  ###################
  # FOR LOCAL SOURCE
  # base_source_url = "../../..//modules/vpc"
  ###################
  name   = "vpc-${local.env_region_metadata}-${local.account_name}-${local.suffix}"
  region = local.region

  cidr             = "10.0.0.0/16"
  azs              = ["us-east-1a", "us-east-1b"]       #, "us-east-1c", "us-east-1d"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]     #, "10.0.3.0/24", "10.0.4.0/24"] # 256 IPs per subnet
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] #, "10.0.103.0/24", "10.0.104.0/24"]
  database_subnets = ["10.0.105.0/24", "10.0.106.0/24"] #, "10.0.107.0/24", "10.0.108.0/24"]
  intra_subnets    = []

  enable_flow_log                      = false # not in development
  create_flow_log_cloudwatch_iam_role  = false
  create_flow_log_cloudwatch_log_group = false
  enable_nat_gateway                   = true
  single_nat_gateway                   = false
  enable_dns_hostnames                 = true
  enable_vpn_gateway                   = false

  public_subnet_tags = {
    "Tier" = "public"
  }
  private_subnet_tags = {
    "Tier" = "private"
  }
  database_subnet_tags = {
    "Tier" = "database"
  }
}