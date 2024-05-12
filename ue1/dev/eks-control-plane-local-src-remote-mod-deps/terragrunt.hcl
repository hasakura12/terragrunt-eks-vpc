# LOCAL TESTING PARAMETERES
# pwd terragrunt-eks-vpc/ue1/dev/LOCAL_SRC_REMOTE_MOD_DEPS/eks-control-plane-local-src-remote-mod-deps/terragrunt.hcl
# --terragrunt-source-update: When passed in, delete the contents of the temporary folder before downloading Terraform source code into it.
# terragrunt plan --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache


# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/TEST/LOCAL_SRC_REMOTE_MOD_DEPS/eks-control-plane-local-src-remote-mod-deps.hcl"

  # TEST 1
  # get_parent_terragrunt_dir("root") returns ROOT of terragrunt.hcl folder: "/terraform", if without include "root" {} to combine root .hcl to curr folder
  # path           = "${get_parent_terragrunt_dir()}/_envcommon/TEST/LOCAL_SRC_REMOTE_MOD_DEPS/eks-control-plane-local-src-remote-mod-deps.hcl"

  # TEST2
  # get_terragrunt_dir() returns LEAF of terragrunt.hcl folder: "/terraform/ue1/dev/eks"
  # path           = "${get_terragrunt_dir()}/_envcommon/TEST/LOCAL_SRC_REMOTE_MOD_DEPS/eks-control-plane-local-src-remote-mod-deps.hcl"

  merge_strategy = "deep" # parent and child's input map will be concatenated. Ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include

  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../DEP_DIR_NAME"" in the parent config, IF there is dependency {} in parent, that'll mess up path.
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("DEP_DIR_NAME")" or 2) comment out "expose = true"
  # ERRO[0000] Could not convert include to the execution context to evaluate additional locals in file /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl 
  # ERRO[0000] Encountered error while evaluating locals in file /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl 
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/vpc: open /terragrunt-eks-vpc/vpc: no such file or directory 
  # ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
  expose = true # by default, local var can't be inherited from parent config. 
}
