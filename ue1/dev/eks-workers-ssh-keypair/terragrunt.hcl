# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-workers-ssh-keypair.hcl"
}

inputs = {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD9VtcNL6rc8V0mO0zIh0gXVjTAK4vFtg8dQ9vZMSdUaDa5YJ746ALVaueGqaPPB8bfhJp/PyN26Xpm/C+ezN3a7CVuAoKaBRtxK1fg+pRh+7G9wtUtmSw1ydN0VMIWm7M+jgIJe7LG4Wnzn/R60zyosewVysgzbi6oRPRUvI5jC0P3BVrr23UBA5jr8bDlZMap8kQBdhKU5ik/UWJm7dH7HD1XG5dPSTy6BlpyRfQZzTYxuiAskIGyv8rDkCpASQe/aAz1Tql8/ijWGPivMN6hzP5i7pKwmuSZrFmMmPun6omdYTyj+ifIPuZmbvEnfYDuC6rp5wlz1uUZKa7AKlvx+fzPOVkQEc34m2yOkFq6Gs2LtnKIgT8Cmh5AksQyI3WX73V047JJAcAlobhwhH8qBQTsV+Rz3mbd985NSrocl5E108dBTCLkRF1WtZosZ79xh75tpsz+BzdOVYbLRY5AyDF47lHxnKQkkchpCzKJSleeHGe4+8PjVSjE1tPLMW0= zta21015@ZTA21015.local"
}