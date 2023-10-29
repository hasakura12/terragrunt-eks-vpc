# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-control-plane.hcl"

  # WARNING: # can't use this when there is dependency {} in parent config, that'll mess up path
  # ERRO[0000] Could not convert include to the execution context to evaluate additional locals in file /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl 
  # ERRO[0000] Encountered error while evaluating locals in file /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl 
  # ERRO[0000] Error reading file at path /terragrunt-eks-vpc/vpc: open /terragrunt-eks-vpc/vpc: no such file or directory 
  # ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
  # expose         = true  
}
