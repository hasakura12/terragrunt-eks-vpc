# Expected Terraform Plan Output

```sh
Terraform will perform the following actions:

  # data.aws_iam_policy_document.k8s_api_server_decryption will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "k8s_api_server_decryption" {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "kms:*",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow access for Key Administrators"

          + principals {
              + identifiers = [
                  + "arn:aws:iam::266981300450:root",
                ]
              + type        = "AWS"
            }
        }
      + statement {
          + actions   = [
              + "kms:Decrypt",
              + "kms:DescribeKey",
              + "kms:Encrypt",
              + "kms:GenerateDataKey*",
              + "kms:ReEncrypt*",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow service-linked role use of the CMK"

          + principals {
              + identifiers = [
                  + "arn:aws:iam::266981300450:root",
                  + (known after apply),
                ]
              + type        = "AWS"
            }
        }
      + statement {
          + actions   = [
              + "kms:CreateGrant",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow attachment of persistent resources"

          + condition {
              + test     = "Bool"
              + values   = [
                  + "true",
                ]
              + variable = "kms:GrantIsForAWSResource"
            }

          + principals {
              + identifiers = [
                  + (known after apply),
                ]
              + type        = "AWS"
            }
        }
    }

  # aws_cloudwatch_log_group.cluster will be created
  + resource "aws_cloudwatch_log_group" "cluster" {
      + arn               = (known after apply)
      + id                = (known after apply)
      + name              = "/aws/eks/eks-dev-ue1/cluster"
      + name_prefix       = (known after apply)
      + retention_in_days = 7
      + skip_destroy      = false
      + tags_all          = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # aws_eks_cluster.this will be created
  + resource "aws_eks_cluster" "this" {
      + arn                       = (known after apply)
      + certificate_authority     = (known after apply)
      + cluster_id                = (known after apply)
      + created_at                = (known after apply)
      + enabled_cluster_log_types = [
          + "api",
          + "audit",
          + "authenticator",
          + "controllerManager",
          + "scheduler",
        ]
      + endpoint                  = (known after apply)
      + id                        = (known after apply)
      + identity                  = (known after apply)
      + name                      = "eks-dev-ue1"
      + platform_version          = (known after apply)
      + role_arn                  = (known after apply)
      + status                    = (known after apply)
      + tags_all                  = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + version                   = "1.28"

      + encryption_config {
          + resources = [
              + "secrets",
            ]

          + provider {
              + key_arn = (known after apply)
            }
        }

      + vpc_config {
          + cluster_security_group_id = (known after apply)
          + endpoint_private_access   = false
          + endpoint_public_access    = true
          + public_access_cidrs       = (known after apply)
          + subnet_ids                = [
              + "subnet-0367004020158c910",
              + "subnet-077d5e651eaa1de95",
              + "subnet-086052dde32c1863f",
              + "subnet-0d654698c5928c536",
            ]
          + vpc_id                    = (known after apply)
        }
    }

  # aws_iam_role.cluster will be created
  + resource "aws_iam_role" "cluster" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "eks.amazonaws.com"
                        }
                      + Sid       = "EKSClusterAssumeRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "eks-cluster-control-plane"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy_attachment.EKSClusterPolicy will be created
  + resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      + role       = "eks-cluster-control-plane"
    }

  # aws_iam_role_policy_attachment.EKSVPCResourceController will be created
  + resource "aws_iam_role_policy_attachment" "EKSVPCResourceController" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
      + role       = "eks-cluster-control-plane"
    }

  # aws_kms_alias.k8s_secret will be created
  + resource "aws_kms_alias" "k8s_secret" {
      + arn            = (known after apply)
      + id             = (known after apply)
      + name           = "alias/cmk-dev-ue1-k8s-secret-dek"
      + name_prefix    = (known after apply)
      + target_key_arn = (known after apply)
      + target_key_id  = (known after apply)
    }

  # aws_kms_key.k8s_secret will be created
  + resource "aws_kms_key" "k8s_secret" {
      + arn                                = (known after apply)
      + bypass_policy_lockout_safety_check = false
      + customer_master_key_spec           = "SYMMETRIC_DEFAULT"
      + deletion_window_in_days            = 30
      + description                        = "Kms key used for encrypting K8s secret DEK (data encryption key)"
      + enable_key_rotation                = true
      + id                                 = (known after apply)
      + is_enabled                         = true
      + key_id                             = (known after apply)
      + key_usage                          = "ENCRYPT_DECRYPT"
      + multi_region                       = (known after apply)
      + policy                             = (known after apply)
      + tags_all                           = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # aws_security_group.cluster will be created
  + resource "aws_security_group" "cluster" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "eks-dev-ue1-cluster"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id                 = "vpc-02de7e4cf2abfbd86"
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_arn                        = (known after apply)
  + cluster_certificate_authority_data = (known after apply)
  + cluster_cloudwatch_logs_arn        = (known after apply)
  + cluster_endpoint                   = (known after apply)
  + cluster_iam_role_arn               = (known after apply)
  + cluster_iam_role_name              = "eks-cluster-control-plane"
  + cluster_iam_role_unique_id         = (known after apply)
  + cluster_id                         = (known after apply)
  + cluster_name                       = "eks-dev-ue1"
  + cluster_platform_version           = (known after apply)
  + cluster_secret_alias_arn           = (known after apply)
  + cluster_secret_id                  = (known after apply)
  + cluster_secret_kms_arn             = (known after apply)
  + cluster_status                     = (known after apply)
  + cluster_version                    = "1.28"
```