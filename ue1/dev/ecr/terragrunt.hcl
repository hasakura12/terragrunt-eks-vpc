# LOCAL TESTING PARAMETERES
# pwd terraform-eks-ping-pong/terraform/ue1/dev/ecr
# terragrunt plan --terragrunt-download-dir ~/terragrunt-cache # remote source

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/TEST/ecr.hcl"
  merge_strategy = "deep" # parent and child's input map will be concatenated. Ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include
  expose         = true   # by default, local var can't be inherited from parent config. 
}

locals {}

inputs = {}