# Expected Terraform Plan Outputs

```sh
Terraform will perform the following actions:

  # aws_iam_openid_connect_provider.oidc_provider will be created
  + resource "aws_iam_openid_connect_provider" "oidc_provider" {
      + arn             = (known after apply)
      + client_id_list  = [
          + "sts.amazonaws.com",
        ]
      + id              = (known after apply)
      + tags            = {
          + "Name" = "eks-dev-ue1-eks-irsa"
        }
      + tags_all        = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "eks-dev-ue1-eks-irsa"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + thumbprint_list = [
          + "9e99a48a9960b14926bb7f3b02e22da2b0ab7280",
        ]
      + url             = "https://oidc.eks.us-east-1.amazonaws.com/id/D02A4C29FEF251ED0CC96BF17272ED81"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_openid_connect_provider_arn             = (known after apply)
  + cluster_openid_connect_provider_client_id_list  = [
      + "sts.amazonaws.com",
    ]
  + cluster_openid_connect_provider_thumbprint_list = [
      + "9e99a48a9960b14926bb7f3b02e22da2b0ab7280",
    ]
  + cluster_openid_connect_provider_url             = "https://oidc.eks.us-east-1.amazonaws.com/id/D02A4C29FEF251ED0CC96BF17272ED81"
```