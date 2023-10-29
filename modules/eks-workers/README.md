# Expected Terraform Plan Output

```sh
Terraform will perform the following actions:

  # aws_security_group.node[0] will be created
  + resource "aws_security_group" "node" {
      + arn                    = (known after apply)
      + description            = "EKS node shared security group"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = "eks-dev-ue1-node-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name"                              = "eks-dev-ue1-node"
          + "kubernetes.io/cluster/eks-dev-ue1" = "owned"
        }
      + tags_all               = {
          + "App"                               = "terragrunt-eks-vpc"
          + "Env"                               = "dev"
          + "Name"                              = "eks-dev-ue1-node"
          + "Region"                            = "us-east-1"
          + "Region_Tag"                        = "ue1"
          + "kubernetes.io/cluster/eks-dev-ue1" = "owned"
        }
      + vpc_id                 = "vpc-02de7e4cf2abfbd86"
    }

  # aws_security_group_rule.node["egress_all"] will be created
  + resource "aws_security_group_rule" "node" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "Allow all egress"
      + from_port                = 0
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "-1"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 0
      + type                     = "egress"
    }

  # aws_security_group_rule.node["ingress_cluster_443"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node groups"
      + from_port                = 443
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 443
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_cluster_4443_webhook"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node 4443/tcp webhook"
      + from_port                = 4443
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 4443
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_cluster_6443_webhook"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node 6443/tcp webhook"
      + from_port                = 6443
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 6443
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_cluster_8443_webhook"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node 8443/tcp webhook"
      + from_port                = 8443
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 8443
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_cluster_9443_webhook"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node 9443/tcp webhook"
      + from_port                = 9443
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 9443
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_cluster_kubelet"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Cluster API to node kubelets"
      + from_port                = 10250
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-0a86570bcadc3a22a"
      + to_port                  = 10250
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_nodes_ephemeral"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Node to node ingress on ephemeral ports"
      + from_port                = 1025
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = true
      + source_security_group_id = (known after apply)
      + to_port                  = 65535
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_self_coredns_tcp"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Node to node CoreDNS"
      + from_port                = 53
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = true
      + source_security_group_id = (known after apply)
      + to_port                  = 53
      + type                     = "ingress"
    }

  # aws_security_group_rule.node["ingress_self_coredns_udp"] will be created
  + resource "aws_security_group_rule" "node" {
      + description              = "Node to node CoreDNS UDP"
      + from_port                = 53
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "udp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = true
      + source_security_group_id = (known after apply)
      + to_port                  = 53
      + type                     = "ingress"
    }

  # time_sleep.this[0] will be created
  + resource "time_sleep" "this" {
      + create_duration = "30s"
      + id              = (known after apply)
      + triggers        = {
          + "cluster_certificate_authority_data" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJV212VHc3b3V3aUV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpFd01qa3dOREU1TWpsYUZ3MHpNekV3TWpZd05ESTBNamxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURYVHNkTlZJWjAybEtlTW03K3FjRmpaYjlxSXVKV0J0YmljdjdDcWlHMEZHUmFLelp4Tzh5VFlwN0UKQ0daYnR6YmZqd0RaSTdxZDU4V3ArSGxobzZxaW5Ca0FUUFJrU00yaVhFVUJpVDZLSlBWUEZPcGJOTEVtMVhnWgpEcVliNWZPRTYrM2M1QXE4UlZSOUI2dUcrOWxoNk5pUjgvV2hiRmswRW5CeTJqVGtIeXY5NVloL0UxWWJ6eklWCnEyOFNMRkFjRlRXaWRKcFAxbm9Sblg4eE1lQ0k5N3o2NzBmRG44Y3FMSEtGeXFXME4zQnNRNmhKRnBTMnF0amYKYm1Kek1ZWjNwQy9SUjlMVElMMWNyemdoWXFhMnJQU3NVU2MvTndnY2N6QkJtbFZHTE10SWZLbStlRHBnbnV0awpYVEJBWkVqdW50RVhUby9QRm4zNDBKR0E4c3Q5QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRMkg5V05oR1ZpT1JLbUgvbTlBd2hLalVnYThUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQlFMVXNVNjUyUgpmRW5oaDAyNmJTNlRtNDVCbUFnRGo3ejlDNW5uMzhJclR3SUpGMzdrMDVyTEppME83Nkc2b2dDV3FVVjM1S3RUCnoyd1NseUdFcHJFc2RweE5abEVxRjhyakdCY3ROdjV0RkVpeXRwSEg1U1FhTFBYSndZY0NZQytuQVZIVFNzcUcKcWtuODV6amRhUGR3YlBvWTlpUEpSYTRzbmp5T0NTUk9Rc3U3eUdRTVZYSHQ3NVhxTmlIcFA1Zm9ZVXBCU0JHRgpXUjlOc2Ewa2R2N2x5V2c1dlY5bnJhMU9tWmt3cjYzR3ZXVzJTbWU1VUc0NndZdVJ0OS9uOW14TXk5cWFvNXdmCmhXUmo1UEIxdXJFMjhzOGtjN2Z3MG5HVU5vY2l3SmpHNnZaY1hoNWdpYS9TK2hjeGZFWXBWNjEwMlR0Q3k3QjYKWjd3c2JScG1pRjR3Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
          + "cluster_endpoint"                   = "https://D02A4C29FEF251ED0CC96BF17272ED81.gr7.us-east-1.eks.amazonaws.com"
          + "cluster_name"                       = "eks-dev-ue1"
          + "cluster_version"                    = "1.28"
        }
    }

  # module.self_managed_node_group["c1.medium"].aws_autoscaling_group.this[0] will be created
  + resource "aws_autoscaling_group" "this" {
      + arn                              = (known after apply)
      + availability_zones               = (known after apply)
      + default_cooldown                 = (known after apply)
      + desired_capacity                 = 1
      + force_delete                     = false
      + force_delete_warm_pool           = false
      + health_check_grace_period        = 300
      + health_check_type                = (known after apply)
      + id                               = (known after apply)
      + ignore_failed_scaling_activities = false
      + load_balancers                   = (known after apply)
      + max_size                         = 1
      + metrics_granularity              = "1Minute"
      + min_size                         = 0
      + name                             = (known after apply)
      + name_prefix                      = "dev-c1medium-"
      + predicted_capacity               = (known after apply)
      + protect_from_scale_in            = false
      + service_linked_role_arn          = (known after apply)
      + target_group_arns                = (known after apply)
      + termination_policies             = []
      + vpc_zone_identifier              = [
          + "subnet-0367004020158c910",
          + "subnet-077d5e651eaa1de95",
          + "subnet-086052dde32c1863f",
          + "subnet-0d654698c5928c536",
        ]
      + wait_for_capacity_timeout        = "10m"
      + warm_pool_size                   = (known after apply)

      + instance_refresh {
          + strategy = "Rolling"

          + preferences {
              + min_healthy_percentage       = 66
              + scale_in_protected_instances = "Ignore"
              + skip_matching                = false
              + standby_instances            = "Ignore"
            }
        }

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = (known after apply)
        }

      + tag {
          + key                 = "Name"
          + propagate_at_launch = true
          + value               = "dev-c1medium"
        }
      + tag {
          + key                 = "k8s.io/cluster-autoscaler/enabled"
          + propagate_at_launch = true
          + value               = "true"
        }
      + tag {
          + key                 = "k8s.io/cluster/eks-dev-ue1"
          + propagate_at_launch = true
          + value               = "owned"
        }
      + tag {
          + key                 = "k8s_namespace"
          + propagate_at_launch = true
          + value               = "dev"
        }
      + tag {
          + key                 = "kubernetes.io/cluster/eks-dev-ue1"
          + propagate_at_launch = true
          + value               = "owned"
        }
      + tag {
          + key                 = "self-managed-node"
          + propagate_at_launch = true
          + value               = "true"
        }

      + timeouts {}
    }

  # module.self_managed_node_group["c1.medium"].aws_iam_instance_profile.this[0] will be created
  + resource "aws_iam_instance_profile" "this" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = (known after apply)
      + name_prefix = "dev-c1medium-node-group-"
      + path        = "/"
      + role        = (known after apply)
      + tags        = {
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + tags_all    = {
          + "App"                               = "terragrunt-eks-vpc"
          + "Env"                               = "dev"
          + "Region"                            = "us-east-1"
          + "Region_Tag"                        = "ue1"
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + unique_id   = (known after apply)
    }

  # module.self_managed_node_group["c1.medium"].aws_iam_role.this[0] will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                      + Sid       = "EKSNodeAssumeRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "Self managed node group IAM role"
      + force_detach_policies = true
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = (known after apply)
      + name_prefix           = "dev-c1medium-node-group-"
      + path                  = "/"
      + tags                  = {
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + tags_all              = {
          + "App"                               = "terragrunt-eks-vpc"
          + "Env"                               = "dev"
          + "Region"                            = "us-east-1"
          + "Region_Tag"                        = "ue1"
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + unique_id             = (known after apply)
    }

  # module.self_managed_node_group["c1.medium"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"] will be created
  + resource "aws_iam_role_policy_attachment" "this" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      + role       = (known after apply)
    }

  # module.self_managed_node_group["c1.medium"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"] will be created
  + resource "aws_iam_role_policy_attachment" "this" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      + role       = (known after apply)
    }

  # module.self_managed_node_group["c1.medium"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"] will be created
  + resource "aws_iam_role_policy_attachment" "this" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      + role       = (known after apply)
    }

  # module.self_managed_node_group["c1.medium"].aws_launch_template.this[0] will be created
  + resource "aws_launch_template" "this" {
      + arn                    = (known after apply)
      + default_version        = (known after apply)
      + description            = "Custom launch template for dev-c1medium self managed node group"
      + id                     = (known after apply)
      + image_id               = "ami-0dd7006cb3a28d563"
      + instance_type          = "c1.medium"
      + latest_version         = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = "c1.medium-"
      + tags                   = {
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + tags_all               = {
          + "App"                               = "terragrunt-eks-vpc"
          + "Env"                               = "dev"
          + "Region"                            = "us-east-1"
          + "Region_Tag"                        = "ue1"
          + "k8s.io/cluster-autoscaler/enabled" = "true"
          + "k8s_namespace"                     = "dev"
          + "self-managed-node"                 = "true"
        }
      + update_default_version = true
      + user_data              = "IyEvYmluL2Jhc2gKc2V0IC1lCkI2NF9DTFVTVEVSX0NBPUxTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJDVkVORFFXVXlaMEYzU1VKQlowbEpWMjEyVkhjM2IzVjNhVVYzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkR1ZFVlVUVUpGUjBFeFZVVUtRWGhOUzJFelZtbGFXRXAxV2xoU2JHTjZRV1ZHZHpCNVRYcEZkMDFxYTNkT1JFVTFUV3BzWVVaM01IcE5la1YzVFdwWmQwNUVTVEJOYW14aFRVSlZlQXBGZWtGU1FtZE9Wa0pCVFZSRGJYUXhXVzFXZVdKdFZqQmFXRTEzWjJkRmFVMUJNRWREVTNGSFUwbGlNMFJSUlVKQlVWVkJRVFJKUWtSM1FYZG5aMFZMQ2tGdlNVSkJVVVJZVkhOa1RsWkpXakF5YkV0bFRXMDNLM0ZqUm1wYVlqbHhTWFZLVjBKMFltbGpkamREY1dsSE1FWkhVbUZMZWxwNFR6aDVWRmx3TjBVS1EwZGFZblI2WW1acWQwUmFTVGR4WkRVNFYzQXJTR3hvYnpaeGFXNUNhMEZVVUZKclUwMHlhVmhGVlVKcFZEWkxTbEJXVUVaUGNHSk9URVZ0TVZobldncEVjVmxpTldaUFJUWXJNMk0xUVhFNFVsWlNPVUkyZFVjck9XeG9OazVwVWpndlYyaGlSbXN3Ulc1Q2VUSnFWR3RJZVhZNU5WbG9MMFV4V1dKNmVrbFdDbkV5T0ZOTVJrRmpSbFJYYVdSS2NGQXhibTlTYmxnNGVFMWxRMGs1TjNvMk56Qm1SRzQ0WTNGTVNFdEdlWEZYTUU0elFuTlJObWhLUm5CVE1uRjBhbVlLWW0xS2VrMVpXak53UXk5U1VqbE1WRWxNTVdOeWVtZG9XWEZoTW5KUVUzTlZVMk12VG5kblkyTjZRa0p0YkZaSFRFMTBTV1pMYlN0bFJIQm5iblYwYXdwWVZFSkJXa1ZxZFc1MFJWaFVieTlRUm00ek5EQktSMEU0YzNRNVFXZE5Ra0ZCUjJwWFZFSllUVUUwUjBFeFZXUkVkMFZDTDNkUlJVRjNTVU53UkVGUUNrSm5UbFpJVWsxQ1FXWTRSVUpVUVVSQlVVZ3ZUVUl3UjBFeFZXUkVaMUZYUWtKUk1rZzVWMDVvUjFacFQxSkxiVWd2YlRsQmQyaExhbFZuWVRoVVFWWUtRbWRPVmtoU1JVVkVha0ZOWjJkd2NtUlhTbXhqYlRWc1pFZFdlazFCTUVkRFUzRkhVMGxpTTBSUlJVSkRkMVZCUVRSSlFrRlJRbEZNVlhOVk5qVXlVZ3BtUlc1b2FEQXlObUpUTmxSdE5EVkNiVUZuUkdvM2VqbEROVzV1TXpoSmNsUjNTVXBHTXpkck1EVnlURXBwTUU4M05rYzJiMmREVjNGVlZqTTFTM1JVQ25veWQxTnNlVWRGY0hKRmMyUndlRTVhYkVWeFJqaHlha2RDWTNST2RqVjBSa1ZwZVhSd1NFZzFVMUZoVEZCWVNuZFpZME5aUXl0dVFWWklWRk56Y1VjS2NXdHVPRFY2YW1SaFVHUjNZbEJ2V1RscFVFcFNZVFJ6Ym1wNVQwTlRVazlSYzNVM2VVZFJUVlpZU0hRM05WaHhUbWxJY0ZBMVptOVpWWEJDVTBKSFJncFhVamxPYzJFd2EyUjJOMng1VjJjMWRsWTVibkpoTVU5dFdtdDNjall6UjNaWFZ6SlRiV1UxVlVjME5uZFpkVkowT1M5dU9XMTRUWGs1Y1dGdk5YZG1DbWhYVW1vMVVFSXhkWEpGTWpoek9HdGpOMlozTUc1SFZVNXZZMmwzU21wSE5uWmFZMWhvTldkcFlTOVRLMmhqZUdaRldYQldOakV3TWxSMFEzazNRallLV2pkM2MySlNjRzFwUmpSM0NpMHRMUzB0UlU1RUlFTkZVbFJKUmtsRFFWUkZMUzB0TFMwSwpBUElfU0VSVkVSX1VSTD1odHRwczovL0QwMkE0QzI5RkVGMjUxRUQwQ0M5NkJGMTcyNzJFRDgxLmdyNy51cy1lYXN0LTEuZWtzLmFtYXpvbmF3cy5jb20KL2V0Yy9la3MvYm9vdHN0cmFwLnNoIGVrcy1kZXYtdWUxIC0ta3ViZWxldC1leHRyYS1hcmdzICctLW5vZGUtbGFiZWxzPWVudj1kZXYsc2VsZi1tYW5hZ2VkLW5vZGU9dHJ1ZSxyZWdpb249dWUxLGs4c19uYW1lc3BhY2U9ZGV2ICAtLXJlZ2lzdGVyLXdpdGgtdGFpbnRzPWRldi1vbmx5PXRydWU6UHJlZmVyTm9TY2hlZHVsZScgLS1iNjQtY2x1c3Rlci1jYSAkQjY0X0NMVVNURVJfQ0EgLS1hcGlzZXJ2ZXItZW5kcG9pbnQgJEFQSV9TRVJWRVJfVVJMCiMgdGhpcyBpcyB0byBjb21wbGV0ZWx5IGJsb2NrIGFsbCBjb250YWluZXJzIHJ1bm5pbmcgb24gYSB3b3JrZXIgbm9kZSBmcm9tIHF1ZXJ5aW5nIHRoZSBpbnN0YW5jZSBtZXRhZGF0YSBzZXJ2aWNlIGZvciBhbnkgbWV0YWRhdGEgdG8gYXZvaWQgcG9kcyBmcm9tIHVzaW5nIG5vZGUncyBJQU0gaW5zdGFuY2UgcHJvZmlsZQojIHJlZjogaHR0cHM6Ly9kb2NzLmF3cy5hbWF6b24uY29tL2Vrcy9sYXRlc3QvdXNlcmd1aWRlL3Jlc3RyaWN0LWVjMi1jcmVkZW50aWFsLWFjY2Vzcy5odG1sCnl1bSBpbnN0YWxsIC15IGlwdGFibGVzLXNlcnZpY2VzOyBpcHRhYmxlcyAtLWluc2VydCBGT1JXQVJEIDEgLS1pbi1pbnRlcmZhY2UgZW5pKyAtLWRlc3RpbmF0aW9uIDE2OS4yNTQuMTY5LjI1NC8zMiAtLWp1bXAgRFJPUDsgaXB0YWJsZXMtc2F2ZSB8IHRlZSAvZXRjL3N5c2NvbmZpZy9pcHRhYmxlczsgc3lzdGVtY3RsIGVuYWJsZSAtLW5vdyBpcHRhYmxlczsKCiMgaW5zdGFsbCBJbnNwZWN0b3IgYWdlbnQKY3VybCAtTyBodHRwczovL2luc3BlY3Rvci1hZ2VudC5hbWF6b25hd3MuY29tL2xpbnV4L2xhdGVzdC9pbnN0YWxsOyBzdWRvIGJhc2ggaW5zdGFsbDsKCiMgaW5zdGFsbCBTU00gYWdlbnQKc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwczovL3MzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2FtYXpvbi1zc20tdXMtZWFzdC0xL2xhdGVzdC9saW51eF9hbWQ2NC9hbWF6b24tc3NtLWFnZW50LnJwbTsgc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGFtYXpvbi1zc20tYWdlbnQ7IHN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGFtYXpvbi1zc20tYWdlbnQ7Cgo="
      + vpc_security_group_ids = (known after apply)

      + block_device_mappings {
          + device_name = "/dev/xvda"

          + ebs {
              + delete_on_termination = "true"
              + encrypted             = "true"
              + iops                  = (known after apply)
              + kms_key_id            = "arn:aws:kms:us-east-1:266981300450:key/31cb16cd-c412-4028-ada1-93ea033f46e3"
              + throughput            = (known after apply)
              + volume_size           = 10
              + volume_type           = "gp3"
            }
        }

      + iam_instance_profile {
          + arn = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = "enabled"
          + http_protocol_ipv6          = (known after apply)
          + http_put_response_hop_limit = 2
          + http_tokens                 = "required"
          + instance_metadata_tags      = (known after apply)
        }

      + monitoring {
          + enabled = true
        }

      + tag_specifications {
          + resource_type = "instance"
          + tags          = {
              + "Name"                              = "dev-c1medium"
              + "k8s.io/cluster-autoscaler/enabled" = "true"
              + "k8s_namespace"                     = "dev"
              + "self-managed-node"                 = "true"
            }
        }
      + tag_specifications {
          + resource_type = "network-interface"
          + tags          = {
              + "Name"                              = "dev-c1medium"
              + "k8s.io/cluster-autoscaler/enabled" = "true"
              + "k8s_namespace"                     = "dev"
              + "self-managed-node"                 = "true"
            }
        }
      + tag_specifications {
          + resource_type = "volume"
          + tags          = {
              + "Name"                              = "dev-c1medium"
              + "k8s.io/cluster-autoscaler/enabled" = "true"
              + "k8s_namespace"                     = "dev"
              + "self-managed-node"                 = "true"
            }
        }
    }

Plan: 19 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + node_security_group_arn  = (known after apply)
  + node_security_group_id   = (known after apply)
  + self_managed_node_groups = {
      + "c1.medium" = {
          + cluster_workers_autoscaling_group_arn                       = (known after apply)
          + cluster_workers_autoscaling_group_availability_zones        = (known after apply)
          + cluster_workers_autoscaling_group_default_cooldown          = (known after apply)
          + cluster_workers_autoscaling_group_desired_capacity          = 1
          + cluster_workers_autoscaling_group_health_check_grace_period = 300
          + cluster_workers_autoscaling_group_health_check_type         = (known after apply)
          + cluster_workers_autoscaling_group_id                        = (known after apply)
          + cluster_workers_autoscaling_group_max_size                  = 1
          + cluster_workers_autoscaling_group_min_size                  = 0
          + cluster_workers_autoscaling_group_name                      = (known after apply)
          + cluster_workers_autoscaling_group_schedule_arns             = {}
          + cluster_workers_autoscaling_group_vpc_zone_identifier       = [
              + "subnet-0367004020158c910",
              + "subnet-077d5e651eaa1de95",
              + "subnet-086052dde32c1863f",
              + "subnet-0d654698c5928c536",
            ]
          + cluster_workers_iam_instance_profile_arn                    = (known after apply)
          + cluster_workers_iam_instance_profile_id                     = (known after apply)
          + cluster_workers_iam_instance_profile_unique                 = (known after apply)
          + cluster_workers_iam_role_arn                                = (known after apply)
          + cluster_workers_iam_role_name                               = (known after apply)
          + cluster_workers_iam_role_unique_id                          = (known after apply)
          + cluster_workers_image_id                                    = "ami-0dd7006cb3a28d563"
          + cluster_workers_launch_template_arn                         = (known after apply)
          + cluster_workers_launch_template_id                          = (known after apply)
          + cluster_workers_launch_template_latest_version              = (known after apply)
          + cluster_workers_launch_template_name                        = (known after apply)
          + cluster_workers_platform                                    = "linux"
          + cluster_workers_user_data                                   = "IyEvYmluL2Jhc2gKc2V0IC1lCkI2NF9DTFVTVEVSX0NBPUxTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJDVkVORFFXVXlaMEYzU1VKQlowbEpWMjEyVkhjM2IzVjNhVVYzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkR1ZFVlVUVUpGUjBFeFZVVUtRWGhOUzJFelZtbGFXRXAxV2xoU2JHTjZRV1ZHZHpCNVRYcEZkMDFxYTNkT1JFVTFUV3BzWVVaM01IcE5la1YzVFdwWmQwNUVTVEJOYW14aFRVSlZlQXBGZWtGU1FtZE9Wa0pCVFZSRGJYUXhXVzFXZVdKdFZqQmFXRTEzWjJkRmFVMUJNRWREVTNGSFUwbGlNMFJSUlVKQlVWVkJRVFJKUWtSM1FYZG5aMFZMQ2tGdlNVSkJVVVJZVkhOa1RsWkpXakF5YkV0bFRXMDNLM0ZqUm1wYVlqbHhTWFZLVjBKMFltbGpkamREY1dsSE1FWkhVbUZMZWxwNFR6aDVWRmx3TjBVS1EwZGFZblI2WW1acWQwUmFTVGR4WkRVNFYzQXJTR3hvYnpaeGFXNUNhMEZVVUZKclUwMHlhVmhGVlVKcFZEWkxTbEJXVUVaUGNHSk9URVZ0TVZobldncEVjVmxpTldaUFJUWXJNMk0xUVhFNFVsWlNPVUkyZFVjck9XeG9OazVwVWpndlYyaGlSbXN3Ulc1Q2VUSnFWR3RJZVhZNU5WbG9MMFV4V1dKNmVrbFdDbkV5T0ZOTVJrRmpSbFJYYVdSS2NGQXhibTlTYmxnNGVFMWxRMGs1TjNvMk56Qm1SRzQ0WTNGTVNFdEdlWEZYTUU0elFuTlJObWhLUm5CVE1uRjBhbVlLWW0xS2VrMVpXak53UXk5U1VqbE1WRWxNTVdOeWVtZG9XWEZoTW5KUVUzTlZVMk12VG5kblkyTjZRa0p0YkZaSFRFMTBTV1pMYlN0bFJIQm5iblYwYXdwWVZFSkJXa1ZxZFc1MFJWaFVieTlRUm00ek5EQktSMEU0YzNRNVFXZE5Ra0ZCUjJwWFZFSllUVUUwUjBFeFZXUkVkMFZDTDNkUlJVRjNTVU53UkVGUUNrSm5UbFpJVWsxQ1FXWTRSVUpVUVVSQlVVZ3ZUVUl3UjBFeFZXUkVaMUZYUWtKUk1rZzVWMDVvUjFacFQxSkxiVWd2YlRsQmQyaExhbFZuWVRoVVFWWUtRbWRPVmtoU1JVVkVha0ZOWjJkd2NtUlhTbXhqYlRWc1pFZFdlazFCTUVkRFUzRkhVMGxpTTBSUlJVSkRkMVZCUVRSSlFrRlJRbEZNVlhOVk5qVXlVZ3BtUlc1b2FEQXlObUpUTmxSdE5EVkNiVUZuUkdvM2VqbEROVzV1TXpoSmNsUjNTVXBHTXpkck1EVnlURXBwTUU4M05rYzJiMmREVjNGVlZqTTFTM1JVQ25veWQxTnNlVWRGY0hKRmMyUndlRTVhYkVWeFJqaHlha2RDWTNST2RqVjBSa1ZwZVhSd1NFZzFVMUZoVEZCWVNuZFpZME5aUXl0dVFWWklWRk56Y1VjS2NXdHVPRFY2YW1SaFVHUjNZbEJ2V1RscFVFcFNZVFJ6Ym1wNVQwTlRVazlSYzNVM2VVZFJUVlpZU0hRM05WaHhUbWxJY0ZBMVptOVpWWEJDVTBKSFJncFhVamxPYzJFd2EyUjJOMng1VjJjMWRsWTVibkpoTVU5dFdtdDNjall6UjNaWFZ6SlRiV1UxVlVjME5uZFpkVkowT1M5dU9XMTRUWGs1Y1dGdk5YZG1DbWhYVW1vMVVFSXhkWEpGTWpoek9HdGpOMlozTUc1SFZVNXZZMmwzU21wSE5uWmFZMWhvTldkcFlTOVRLMmhqZUdaRldYQldOakV3TWxSMFEzazNRallLV2pkM2MySlNjRzFwUmpSM0NpMHRMUzB0UlU1RUlFTkZVbFJKUmtsRFFWUkZMUzB0TFMwSwpBUElfU0VSVkVSX1VSTD1odHRwczovL0QwMkE0QzI5RkVGMjUxRUQwQ0M5NkJGMTcyNzJFRDgxLmdyNy51cy1lYXN0LTEuZWtzLmFtYXpvbmF3cy5jb20KL2V0Yy9la3MvYm9vdHN0cmFwLnNoIGVrcy1kZXYtdWUxIC0ta3ViZWxldC1leHRyYS1hcmdzICctLW5vZGUtbGFiZWxzPWVudj1kZXYsc2VsZi1tYW5hZ2VkLW5vZGU9dHJ1ZSxyZWdpb249dWUxLGs4c19uYW1lc3BhY2U9ZGV2ICAtLXJlZ2lzdGVyLXdpdGgtdGFpbnRzPWRldi1vbmx5PXRydWU6UHJlZmVyTm9TY2hlZHVsZScgLS1iNjQtY2x1c3Rlci1jYSAkQjY0X0NMVVNURVJfQ0EgLS1hcGlzZXJ2ZXItZW5kcG9pbnQgJEFQSV9TRVJWRVJfVVJMCiMgdGhpcyBpcyB0byBjb21wbGV0ZWx5IGJsb2NrIGFsbCBjb250YWluZXJzIHJ1bm5pbmcgb24gYSB3b3JrZXIgbm9kZSBmcm9tIHF1ZXJ5aW5nIHRoZSBpbnN0YW5jZSBtZXRhZGF0YSBzZXJ2aWNlIGZvciBhbnkgbWV0YWRhdGEgdG8gYXZvaWQgcG9kcyBmcm9tIHVzaW5nIG5vZGUncyBJQU0gaW5zdGFuY2UgcHJvZmlsZQojIHJlZjogaHR0cHM6Ly9kb2NzLmF3cy5hbWF6b24uY29tL2Vrcy9sYXRlc3QvdXNlcmd1aWRlL3Jlc3RyaWN0LWVjMi1jcmVkZW50aWFsLWFjY2Vzcy5odG1sCnl1bSBpbnN0YWxsIC15IGlwdGFibGVzLXNlcnZpY2VzOyBpcHRhYmxlcyAtLWluc2VydCBGT1JXQVJEIDEgLS1pbi1pbnRlcmZhY2UgZW5pKyAtLWRlc3RpbmF0aW9uIDE2OS4yNTQuMTY5LjI1NC8zMiAtLWp1bXAgRFJPUDsgaXB0YWJsZXMtc2F2ZSB8IHRlZSAvZXRjL3N5c2NvbmZpZy9pcHRhYmxlczsgc3lzdGVtY3RsIGVuYWJsZSAtLW5vdyBpcHRhYmxlczsKCiMgaW5zdGFsbCBJbnNwZWN0b3IgYWdlbnQKY3VybCAtTyBodHRwczovL2luc3BlY3Rvci1hZ2VudC5hbWF6b25hd3MuY29tL2xpbnV4L2xhdGVzdC9pbnN0YWxsOyBzdWRvIGJhc2ggaW5zdGFsbDsKCiMgaW5zdGFsbCBTU00gYWdlbnQKc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwczovL3MzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2FtYXpvbi1zc20tdXMtZWFzdC0xL2xhdGVzdC9saW51eF9hbWQ2NC9hbWF6b24tc3NtLWFnZW50LnJwbTsgc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGFtYXpvbi1zc20tYWdlbnQ7IHN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGFtYXpvbi1zc20tYWdlbnQ7Cgo="
        }
    }
```