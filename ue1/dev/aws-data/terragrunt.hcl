# LOCAL TESTING PARAMETERES
# pwd /terraform/ue1/dev/aws-data
# for local module
# terragrunt apply --terragrunt-source ../../../modules//aws-data --terragrunt-download-dir ~/terragrunt-cache
# for remote module
# terragrunt apply --terragrunt-download-dir ~/terragrunt-cache

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/aws-data.hcl"
  merge_strategy = "deep" # parent and child's input map will be concatenated. Ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include
  expose         = true   # by default, local var can't be inherited from parent config. 
}

inputs = {}