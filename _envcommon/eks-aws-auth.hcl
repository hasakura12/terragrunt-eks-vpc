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
  aws_account_id       = local.account_vars.locals.aws_account_id
  terraform_role_name  = local.account_vars.locals.terraform_role_name
  developer_role_name  = local.account_vars.locals.developer_role_name
  full_admin_role_name = local.account_vars.locals.full_admin_role_name
  env                  = local.environment_vars.locals.env
  region               = local.region_vars.locals.region
  region_tag           = local.region_vars.locals.region_tag

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "../../..//modules/eks-aws-auth" # relative path from execution dir
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../eks-workers"]
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  aws_account_id       = local.aws_account_id
  terraform_role_name  = local.terraform_role_name
  developer_role_name  = local.developer_role_name
  full_admin_role_name = local.full_admin_role_name

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.aws_account_id}:user/dummy-admin-user"
      username = "dummy-admin-user"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${local.aws_account_id}}:user/dummy-viewer-user"
      username = "dummy-viewer-user"
      groups   = ["system:viewers"]
    },
  ]

  aws_auth_accounts = [
    "777777777777",
    "888888888888",
  ]
}