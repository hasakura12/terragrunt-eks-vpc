# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name        = "terragrunt-eks-vpc"
  aws_account_id      = "266981300450"
  terraform_role_name = "Terraform"
  developer_role_name = "Developer"
  admin_role_name     = "Admin"
}