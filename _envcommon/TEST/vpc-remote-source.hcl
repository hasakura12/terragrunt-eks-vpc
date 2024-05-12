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
  suffix              = "remote-src"

  vpc_cidr = "10.1.0.0/16"
  az_names = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
  ]
  az_count     = 2                                                                        # the number of AZs to use
  cluster_name = "eks-${local.env_region_metadata}-${local.account_name}-${local.suffix}" # use "expose = true" in child config to expose this

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR LOCAL SOURCE
  ###################
  # base_source_url = "../../..//modules/vpc" # relative path from execution dir

  ###################
  # FOR REMOTE SOURCE
  ###################
  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git"
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../aws-data"]
}

# Run `terragrunt output` on the module at the relative path, and expose them under the attribute `dependency.NAME.outputs`
dependency "aws-data" {
  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../aws-data"" in the parent config, IF there is dependency {} in parent, that'll mess up path. Resolution is to use "config_path = find_in_parent_folders("aws-data")"
  # ERRO[0000] Could not convert include to the execution context to evaluate additional locals in file /terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl 
  # ERRO[0000] Encountered error while evaluating locals in file /terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl 
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/_envcommon/aws-data: open /terragrunt-eks-vpc/_envcommon/aws-data: no such file or directory 
  # ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
  # config_path = "../aws-data" 

  config_path = find_in_parent_folders("aws-data") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/aws-data: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    available_aws_availability_zones_names = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
    ]
  }

  mock_outputs_merge_strategy_with_state = "shallow" # merge the mocked outputs and the state outputs. Ref: https://github.com/gruntwork-io/terragrunt/issues/1733#issuecomment-878609447
  # WARNING1: # for "apply", mocked outputs won't be used even if "mock_outputs_merge_strategy_with_state = shallow", and might cause "Unsupported attribute; This object does not have an attribute named "cloudwatch_log_group_arn". Some reasons could be: 1) the dependent module hasn't been applied yet, 2) output not defined in outputs.tf, 3) or was defined after terraform-applied, hence terraform.tfstate in S3 doesn't have it yet. (if so, pass --terragrunt-source-update or terragrunt refresh) Ref: https://github.com/gruntwork-io/terragrunt/issues/940#issuecomment-910531856
  # WARNING2: if not "terragrunt apply" yet, you will get error "/terragrunt-eks-vpc/ue1/dev/aws-data/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block."
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name = "vpc-${local.env_region_metadata}-${local.account_name}-${local.suffix}"

  ###################
  # FOR LOCAL SOURCE
  # base_source_url = "../../..//modules/vpc"
  ###################
  # cidr             = "10.11.0.0/16"
  # azs              = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  # public_subnets   = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"] # 256 IPs per subnet
  # private_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24", "10.1.104.0/24"]

  ###################
  # FOR REMOTE SOURCE
  # REFs: 
  #  - https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/self_managed_node_group/main.tf#L322-L346
  #  - https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf#L441-L464
  # base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git"
  ###################
  cidr = local.vpc_cidr
  # azs             = slice(local.az_names, 0, local.az_count)
  azs             = [for v in slice(dependency.aws-data.outputs.available_aws_availability_zones_names, 0, local.az_count) : v]
  public_subnets  = [for k, v in slice(local.az_names, 0, local.az_count) : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  private_subnets = [for k, v in slice(local.az_names, 0, local.az_count) : cidrsubnet(local.vpc_cidr, 4, k)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

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