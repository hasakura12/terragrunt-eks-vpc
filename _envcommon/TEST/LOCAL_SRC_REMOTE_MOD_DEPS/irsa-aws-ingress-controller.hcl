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
  account_name   = local.account_vars.locals.account_name
  aws_account_id = local.account_vars.locals.aws_account_id
  env            = local.environment_vars.locals.env
  region         = local.region_vars.locals.region
  region_tag     = local.region_vars.locals.region_tag

  env_region_metadata = "${local.env}-${local.region_tag[local.region]}"
  suffix              = "local-src-remote-mod-deps"

  role_name       = "load-balancer-controller"
  k8s_namespace   = "kube-system"
  service_account = "aws-load-balancer-controller"

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  ###################
  # FOR REMOTE SOURCE
  ###################
  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-iam.git//modules/iam-role-for-service-accounts-eks"
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../eks-control-plane-local-src-remote-mod-deps"]
}

dependency "eks" {
  config_path = find_in_parent_folders("eks-control-plane-local-src-remote-mod-deps") # NOTE: workaround for error "/terragrunt-eks-vpc/_envcommon/TEST/DEP_DIR_NAME: no such file or directory". So need to use find_in_parent_folders(). Refs: https://stackoverflow.com/a/70180689, https://github.com/gruntwork-io/terragrunt/issues/2933#issuecomment-1932518342

  # ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    oidc_provider_arn = "dummy"
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
  # FOR REMOTE SOURCE
  # REF: https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf#L227
  ###################

  role_name                              = "${local.role_name}-${local.suffix}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = dependency.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace}:${local.service_account}"]
    }
  }
}