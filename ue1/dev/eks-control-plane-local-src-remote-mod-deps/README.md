# Create EKS Control Plane: Local Source Remote Dependencies

## AWS Setup 

For simplicity, Terragrunt/Terraform will assume the `Admin` IAM role to create AWS resources.

Change `aws_account_id` to your AWS account in `account.hcl`:
```sh
locals {
  account_name         = "terragrunt-eks-vpc"
  aws_account_id       = "CHANGE_ME"
  terraform_role_name  = "Terraform"
  developer_role_name  = "Developer"
  admin_role_name      = "Admin"
}
```

Terragrunt will create the following AWS `provider.tf`, defined in the root level `terragrunt.hcl`:
```sh
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/${local.admin_role_name}"
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
```

Assume the `Admin` role when running `terragrunt` CLI
```sh
$ cat ~/.aws/config 
[profile YOUR_PROFILE]
role_arn = arn:aws:iam::YOUR_AWS_ACCOUNT:role/Admin
source_profile = YOUR_PROFILE

$ export AWS_PROFILE=YOUR_PROFILE

$ aws sts get-caller-identity
{
    "UserId": "AROAT4KKTLDRCZPQKAOWK:botocore-session-1715531232",
    "Account": "YOUR_AWS_ACCOUNT",
    "Arn": "arn:aws:sts::YOUR_AWS_ACCOUNT:assumed-role/Admin
}
```


There are two ways to manage infrastructure (slower&complete, or faster&granular):

- **As a Single Layer**

Run this command to create infrastructure in a single layer (eks-control-plane):
```sh
$ cd /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps

$ terragrunt apply --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

# if dependent resources (vpc and eks-control-plane-logs) haven't been applied, you will get error below, then go to dependent module's path and terragrunt apply them before this module
ERRO[0002] /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block. 
ERRO[0002] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
```

- **All dependencies as a whole**

EKS-control-plane consists of multiple dependencies (vpc and eks-control-plane-logs).

`terragrunt run-all apply` will create all resources in one-go:
```sh
$ cd ../eks-control-plane
$ terragrunt run-all plan --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

INFO[0026] The stack at /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-mod-deps will be processed in the following order for command apply:
Group 1
- Module /terragrunt-eks-vpc/ue1/dev/aws-data
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs-local-src-remote-mod-deps
- Module /terragrunt-eks-vpc/ue1/dev/iam-roles-remote-source

Group 2
- Module /terragrunt-eks-vpc/ue1/dev/vpc-remote-source

Group 3
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-mod-deps
 
Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) y
```

# Access EKS Cluster
```sh
EKS_CLUSTER_NAME="eks-dev-ue1-terragrunt-eks-vpc-local-src-remote-mod-deps"
REGION="us-east-1"

$ aws eks update-kubeconfig \
    --name ${EKS_CLUSTER_NAME} \
    --region ${REGION}
```