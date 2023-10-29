locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name        = local.account_vars.locals.account_name
  account_id          = local.account_vars.locals.aws_account_id
  region              = local.region_vars.locals.region
  region_tag          = local.region_vars.locals.region_tag
  terraform_role_name = local.account_vars.locals.terraform_role_name
  env                 = local.environment_vars.locals.env

  cluster_name = "eks-${local.env}-${local.region_tag[local.region]}"
}

# Generate an AWS provider block
# refs: https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/#dry-common-terraform-code-with-terragrunt-generate-blocks, https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#generate
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/${local.terraform_role_name}"
  }

  # ref: https://developer.hashicorp.com/terraform/tutorials/aws/aws-default-tags
  default_tags {
    tags = {
      App    = "${local.account_name}"
      Env    = "${local.env}"
      Region = "${local.region}"
      Region_Tag = "${local.region_tag[local.region]}"
    }
  }

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# this needs to be generated above other eks-related modules level (i.e. "eks-aws-auth/"), so other modules will have this provider-local.tf generated in their dirs to connect to k8s cluster using host & CA cert info
# otherwise will get "Error: Post "http://localhost/api/v1/namespaces/kube-system/configmaps": dial tcp 127.0.0.1:80: connect: connection refused" because without k8s provider config, it'll default to connecting to localhost cluster
# ref: https://github.com/gruntwork-io/terragrunt/issues/1822
generate "provider-k8s-local" {
  path      = "provider-k8s-local.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

    data "aws_eks_cluster" "eks" {
        name = "${local.cluster_name}"
    }

    data "aws_eks_cluster_auth" "eks" {
        name = "${local.cluster_name}"
    }

    provider "kubernetes" {
        host                   = data.aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.eks.token
        # exec {
        #   api_version = "client.authentication.k8s.io/v1beta1"
        #   command     = "aws"
        #   # This requires the awscli to be installed locally where Terraform is executed
        #   args = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
#       }
    }
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}s3-${local.env}-${local.region_tag[local.region]}-${local.account_name}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "dynamo-${local.env}-${local.region_tag[local.region]}-${local.account_name}-terraform-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)