# Expected Terraform Plan Output
```sh
Terraform will perform the following actions:

  # aws_iam_policy.cluster_autoscaler_policy will be created
  + resource "aws_iam_policy" "cluster_autoscaler_policy" {
      + arn         = (known after apply)
      + description = "EKS cluster-autoscaler policy"
      + id          = (known after apply)
      + name        = "EKSClusterAutoscalerPolicy"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:DescribeLaunchTemplateVersions",
                          + "autoscaling:DescribeTags",
                          + "autoscaling:DescribeLaunchConfigurations",
                          + "autoscaling:DescribeAutoScalingInstances",
                          + "autoscaling:DescribeAutoScalingGroups",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "clusterAutoscalerAll"
                    },
                  + {
                      + Action    = [
                          + "autoscaling:UpdateAutoScalingGroup",
                          + "autoscaling:TerminateInstanceInAutoScalingGroup",
                          + "autoscaling:SetDesiredCapacity",
                        ]
                      + Condition = {
                          + StringEquals = {
                              + "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled" = "true"
                            }
                        }
                      + Effect    = "Allow"
                      + Resource  = "*"
                      + Sid       = "clusterAutoscalerOwn"
                    },
                  + {
                      + Action   = [
                          + "eks:DescribeNodegroup",
                          + "ec2:DescribeInstanceTypes",
                          + "autoscaling:DescribeScalingActivities",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "newPolicies"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # aws_iam_role.cluster_autoscaler will be created
  + resource "aws_iam_role" "cluster_autoscaler" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRoleWithWebIdentity"
                      + Condition = {
                          + StringEquals = {
                              + "oidc.eks.us-east-1.amazonaws.com/id/D02A4C29FEF251ED0CC96BF17272ED81:sub" = "system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + Federated = "arn:aws:iam::266981300450:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/D02A4C29FEF251ED0CC96BF17272ED81"
                        }
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
      + name                  = "cluster_autoscaler"
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

  # aws_iam_role_policy_attachment.cluster_autoscaler will be created
  + resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "cluster_autoscaler"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_autoscaler_iam_role_arn       = (known after apply)
  + cluster_autoscaler_iam_role_name      = "cluster_autoscaler"
  + cluster_autoscaler_iam_role_unique_id = (known after apply)
  + description                           = "EKS cluster-autoscaler policy"
  + name                                  = "EKSClusterAutoscalerPolicy"
  + name_prefix                           = (known after apply)
  + path                                  = "/"
  + policy                                = jsonencode(
        {
          + Statement = [
              + {
                  + Action   = [
                      + "ec2:DescribeLaunchTemplateVersions",
                      + "autoscaling:DescribeTags",
                      + "autoscaling:DescribeLaunchConfigurations",
                      + "autoscaling:DescribeAutoScalingInstances",
                      + "autoscaling:DescribeAutoScalingGroups",
                    ]
                  + Effect   = "Allow"
                  + Resource = "*"
                  + Sid      = "clusterAutoscalerAll"
                },
              + {
                  + Action    = [
                      + "autoscaling:UpdateAutoScalingGroup",
                      + "autoscaling:TerminateInstanceInAutoScalingGroup",
                      + "autoscaling:SetDesiredCapacity",
                    ]
                  + Condition = {
                      + StringEquals = {
                          + "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled" = "true"
                        }
                    }
                  + Effect    = "Allow"
                  + Resource  = "*"
                  + Sid       = "clusterAutoscalerOwn"
                },
              + {
                  + Action   = [
                      + "eks:DescribeNodegroup",
                      + "ec2:DescribeInstanceTypes",
                      + "autoscaling:DescribeScalingActivities",
                    ]
                  + Effect   = "Allow"
                  + Resource = "*"
                  + Sid      = "newPolicies"
                },
            ]
          + Version   = "2012-10-17"
        }
    )
  + policy_arn                            = (known after apply)
  + role                                  = "cluster_autoscaler"
```