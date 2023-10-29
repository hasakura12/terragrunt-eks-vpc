# Expected Terraform Plan Output

```sh
Terraform will perform the following actions:

  # aws_eks_addon.this["coredns"] will be created
  + resource "aws_eks_addon" "this" {
      + addon_name           = "coredns"
      + addon_version        = "v1.10.1-eksbuild.4"
      + arn                  = (known after apply)
      + cluster_name         = "eks-dev-ue1"
      + configuration_values = (known after apply)
      + created_at           = (known after apply)
      + id                   = (known after apply)
      + modified_at          = (known after apply)
      + resolve_conflicts    = "OVERWRITE"
      + tags_all             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }

      + timeouts {}
    }

  # aws_eks_addon.this["kube-proxy"] will be created
  + resource "aws_eks_addon" "this" {
      + addon_name           = "kube-proxy"
      + addon_version        = "v1.28.2-eksbuild.2"
      + arn                  = (known after apply)
      + cluster_name         = "eks-dev-ue1"
      + configuration_values = (known after apply)
      + created_at           = (known after apply)
      + id                   = (known after apply)
      + modified_at          = (known after apply)
      + resolve_conflicts    = "OVERWRITE"
      + tags_all             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }

      + timeouts {}
    }

  # aws_eks_addon.this["vpc-cni"] will be created
  + resource "aws_eks_addon" "this" {
      + addon_name           = "vpc-cni"
      + addon_version        = "v1.15.1-eksbuild.1"
      + arn                  = (known after apply)
      + cluster_name         = "eks-dev-ue1"
      + configuration_values = (known after apply)
      + created_at           = (known after apply)
      + id                   = (known after apply)
      + modified_at          = (known after apply)
      + resolve_conflicts    = "OVERWRITE"
      + tags_all             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }

      + timeouts {}
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_addons = {
      + coredns    = {
          + addon_name                  = "coredns"
          + addon_version               = "v1.10.1-eksbuild.4"
          + arn                         = (known after apply)
          + cluster_name                = "eks-dev-ue1"
          + configuration_values        = (known after apply)
          + created_at                  = (known after apply)
          + id                          = (known after apply)
          + modified_at                 = (known after apply)
          + preserve                    = null
          + resolve_conflicts           = "OVERWRITE"
          + resolve_conflicts_on_create = null
          + resolve_conflicts_on_update = null
          + service_account_role_arn    = null
          + tags                        = null
          + tags_all                    = {
              + App        = "terragrunt-eks-vpc"
              + Env        = "dev"
              + Region     = "us-east-1"
              + Region_Tag = "ue1"
            }
          + timeouts                    = {
              + create = null
              + delete = null
              + update = null
            }
        }
      + kube-proxy = {
          + addon_name                  = "kube-proxy"
          + addon_version               = "v1.28.2-eksbuild.2"
          + arn                         = (known after apply)
          + cluster_name                = "eks-dev-ue1"
          + configuration_values        = (known after apply)
          + created_at                  = (known after apply)
          + id                          = (known after apply)
          + modified_at                 = (known after apply)
          + preserve                    = null
          + resolve_conflicts           = "OVERWRITE"
          + resolve_conflicts_on_create = null
          + resolve_conflicts_on_update = null
          + service_account_role_arn    = null
          + tags                        = null
          + tags_all                    = {
              + App        = "terragrunt-eks-vpc"
              + Env        = "dev"
              + Region     = "us-east-1"
              + Region_Tag = "ue1"
            }
          + timeouts                    = {
              + create = null
              + delete = null
              + update = null
            }
        }
      + vpc-cni    = {
          + addon_name                  = "vpc-cni"
          + addon_version               = "v1.15.1-eksbuild.1"
          + arn                         = (known after apply)
          + cluster_name                = "eks-dev-ue1"
          + configuration_values        = (known after apply)
          + created_at                  = (known after apply)
          + id                          = (known after apply)
          + modified_at                 = (known after apply)
          + preserve                    = null
          + resolve_conflicts           = "OVERWRITE"
          + resolve_conflicts_on_create = null
          + resolve_conflicts_on_update = null
          + service_account_role_arn    = null
          + tags                        = null
          + tags_all                    = {
              + App        = "terragrunt-eks-vpc"
              + Env        = "dev"
              + Region     = "us-east-1"
              + Region_Tag = "ue1"
            }
          + timeouts                    = {
              + create = null
              + delete = null
              + update = null
            }
        }
    }
```