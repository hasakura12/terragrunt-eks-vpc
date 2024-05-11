terraform {
  source = local.base_source_url
}

locals {
  # base_source_url = "../../../modules//aws-data" # relative path from execution dir

  base_source_url = "git::git@github.com:antonbabenko/terragrunt-reference-architecture.git//modules/aws-data"
}

inputs = {}