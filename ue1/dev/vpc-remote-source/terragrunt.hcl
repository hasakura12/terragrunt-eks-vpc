# LOCAL TESTING PARAMETERES
# pwd terragrunt-eks-vpc/ue1/dev/vpc-remote-source
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
  path           = "${dirname(find_in_parent_folders())}/_envcommon/TEST/vpc-remote-source.hcl"
  merge_strategy = "deep" # parent and child's input map will be concatenated. Ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include

  # WARNING1: # can't use both "expose = true" in child config and "config_path = "../aws-data"" in the parent config, IF there is dependency {} in parent, that'll mess up path. 
  # RESOLUTION: 1) use "config_path = find_in_parent_folders("aws-data")", or 2) comment out "expose = true"
  # ERRO[0000] Could not convert include to the execution context to evaluate additional locals in file /Users/hasakura/SoftwareDevelopment/EXODUS/terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl 
  # ERRO[0000] Encountered error while evaluating locals in file /Users/hasakura/SoftwareDevelopment/EXODUS/terragrunt-eks-vpc/ue1/dev/vpc-remote-source/terragrunt.hcl 
  # ERRO[0000] Error reading file at path /Users/hasakura/SoftwareDevelopment/EXODUS/terragrunt-eks-vpc/_envcommon/aws-data: open /Users/hasakura/SoftwareDevelopment/EXODUS/terragrunt-eks-vpc/_envcommon/aws-data: no such file or directory 
  # ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
  expose = true # by default, local var can't be inherited from parent config. 
}

locals {
  # locals block is deliberately omitted from the merge operation by design. That is, you will not be able to access parent config locals in the child config, and vice versa in a merge. 
  # However, you can access the parent locals in child config if you use the expose feature.
  # ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include
  cluster_name = include.envcommon.locals.cluster_name # use "expose = true" in child config to access parent's local var
}

inputs = {
  # inputs from parent and child config's maps are merged together, instead of overriden, with deep merge (include { merge_strategy = "deep" }). Ref: https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned" # for ingress controller. Ref: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
    "kubernetes.io/role/internal-elb"             = 1       # for ingress controller. Ref: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned" # for ingress controller. Ref: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
    "kubernetes.io/role/internal-elb"             = 1       # for ingress controller. Ref: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
  }
}