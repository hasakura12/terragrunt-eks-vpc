# LOCAL TESTING PARAMETERES
# pwd terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs
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
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-control-plane-logs.hcl"
}
