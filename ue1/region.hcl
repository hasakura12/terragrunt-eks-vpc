# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  region = "us-east-1"
  region_tag = {
    "us-east-1"    = "ue1"
    "us-west-1"    = "uw1"
    "eu-west-1"    = "ew1"
    "eu-central-1" = "ec1"
  }
}