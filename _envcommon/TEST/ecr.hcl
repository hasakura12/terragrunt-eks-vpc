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
  suffix              = "local-src-remote-deps"
  name                = "ecr-${local.env_region_metadata}-${local.account_name}-${local.suffix}"

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR REMOTE SOURCE
  ###################
  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-ecr.git//"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  ###################
  # FOR REMOTE SOURCE
  # REF: https://github.com/terraform-aws-modules/terraform-aws-ecr/blob/master/examples/complete/main.tf#L30-L58
  ###################

  repository_name = local.name

  repository_read_write_access_arns = [
    "arn:aws:iam::${local.aws_account_id}:role/${local.admin_role_name}",
    "arn:aws:iam::${local.aws_account_id}:role/${local.terraform_role_name}",
  ]
  create_lifecycle_policy         = true
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true
}