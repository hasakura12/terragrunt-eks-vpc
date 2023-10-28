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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
      + source_security_group_id = "sg-07f9d496d9fa67c96"
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
          + "cluster_certificate_authority_data" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJWitFM1pTRkhDL1l3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpFd01qZ3hNelExTWpkYUZ3MHpNekV3TWpVeE16VXdNamRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURJdHJXaEZQdXdCVDEyZ0VKd2oxcVk2MmoxRXl3cXo5eUJjQU1LTmorLzIrV3hURDhyc1JjUWlYaXoKaDd6Q2h3YnR6RWQ3b1dZRjVIOE1JWVJTZGg5U1oxbWVwQjRWbit1bDhQaXpaY09lKzZ6dU5JZnNVeEw1T1hHbgp3MHU1bXZSbldGcXczRmkyOVdyV2tFL0RjS3g1V005c29Pdy81SzhnNkNyN2owcDNkUXdFWFB4ZzdrY2orampxCklLMHo2NG9KYVFjaFJka3NXbmg5VGMxWHc5Z0FXWFRsdHJ0cFVGejBBQXFJRlFQM0J1NDBERjJrS2Y0am5vUUcKSncraEV5M0VIelltK1BNM0tRRW94Z0xxazJuZWxZTzBUdWV3M2FOWi9CT3oxZ0k1dzM5L3dlNnlCejJVVXl3KwpKd2hzN3hZc0RMTmFTUlEwNHJSYzVpV0czLzlyQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUUi9WdjRlbGw3aGtiRWt2TWYvNnZGeG8raGNUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2gwcnd6Y1pjaAo4cHU4elhGRnJxRUVyWTdDM1lxUGZXS2lBRW9FZm1aYkxBWmVuU2xmNnU4RHRaS2dIcWFnQ0xOSXVmRUEybjZtClZUNm5DbURCTWhYOTVreDVvY1ljS3JoRlRRL1orSGlBbm9UUzV4dkhBUUdtVTR0d0pjZGJLd2UrSER2MTgweWYKUlpBTCtvdUFKSDcyYjVxam9XVVI0YXFoRkRRS28wNlVITVpGZFlZZkJLc3VId1JSQkYzVUdUNVNxNXU2dDBQNgphSyt1RVk2K3hBbXN0TlNYZk5RMjI4R1dicVA3Q1JsU2I4ZHExSmR6eFZJb0NNVEpsa2FiaTA5UUdzcjQ4MTMwCktveDZKblF6WE9oSHNCWCtCalVzY0lIVk1hYjBUUFZuT0hwMlJWWFNOQnJGRC84U25RelRvblFvUjRLSjd3bC8KZFNlaTBNU1RGZjFyCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
          + "cluster_endpoint"                   = "https://4336731231B20B6D438985EF23F5EAE1.gr7.us-east-1.eks.amazonaws.com"
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
      + user_data              = "IyEvYmluL2Jhc2gKc2V0IC1lCkI2NF9DTFVTVEVSX0NBPUxTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJDVkVORFFXVXlaMEYzU1VKQlowbEpXaXRGTTFwVFJraERMMWwzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkR1ZFVlVUVUpGUjBFeFZVVUtRWGhOUzJFelZtbGFXRXAxV2xoU2JHTjZRV1ZHZHpCNVRYcEZkMDFxWjNoTmVsRXhUV3BrWVVaM01IcE5la1YzVFdwVmVFMTZWWGROYW1SaFRVSlZlQXBGZWtGU1FtZE9Wa0pCVFZSRGJYUXhXVzFXZVdKdFZqQmFXRTEzWjJkRmFVMUJNRWREVTNGSFUwbGlNMFJSUlVKQlVWVkJRVFJKUWtSM1FYZG5aMFZMQ2tGdlNVSkJVVVJKZEhKWGFFWlFkWGRDVkRFeVowVktkMm94Y1ZrMk1tb3hSWGwzY1hvNWVVSmpRVTFMVG1vckx6SXJWM2hVUkRoeWMxSmpVV2xZYVhvS2FEZDZRMmgzWW5SNlJXUTNiMWRaUmpWSU9FMUpXVkpUWkdnNVUxb3hiV1Z3UWpSV2JpdDFiRGhRYVhwYVkwOWxLelo2ZFU1SlpuTlZlRXcxVDFoSGJncDNNSFUxYlhaU2JsZEdjWGN6Um1reU9WZHlWMnRGTDBSalMzZzFWMDA1YzI5UGR5ODFTemhuTmtOeU4yb3djRE5rVVhkRldGQjRaemRyWTJvcmFtcHhDa2xMTUhvMk5HOUtZVkZqYUZKa2EzTlhibWc1VkdNeFdIYzVaMEZYV0ZSc2RISjBjRlZHZWpCQlFYRkpSbEZRTTBKMU5EQkVSakpyUzJZMGFtNXZVVWNLU25jcmFFVjVNMFZJZWxsdEsxQk5NMHRSUlc5NFoweHhhekp1Wld4WlR6QlVkV1YzTTJGT1dpOUNUM294WjBrMWR6TTVMM2RsTm5sQ2VqSlZWWGwzS3dwS2QyaHpOM2haYzBSTVRtRlRVbEV3TkhKU1l6VnBWMGN6THpseVFXZE5Ra0ZCUjJwWFZFSllUVUUwUjBFeFZXUkVkMFZDTDNkUlJVRjNTVU53UkVGUUNrSm5UbFpJVWsxQ1FXWTRSVUpVUVVSQlVVZ3ZUVUl3UjBFeFZXUkVaMUZYUWtKVVVpOVdkalJsYkd3M2FHdGlSV3QyVFdZdk5uWkdlRzhyYUdOVVFWWUtRbWRPVmtoU1JVVkVha0ZOWjJkd2NtUlhTbXhqYlRWc1pFZFdlazFCTUVkRFUzRkhVMGxpTTBSUlJVSkRkMVZCUVRSSlFrRlJRMmd3Y25kNlkxcGphQW80Y0hVNGVsaEdSbkp4UlVWeVdUZERNMWx4VUdaWFMybEJSVzlGWm0xYVlreEJXbVZ1VTJ4bU5uVTRSSFJhUzJkSWNXRm5RMHhPU1hWbVJVRXlialp0Q2xaVU5tNURiVVJDVFdoWU9UVnJlRFZ2WTFsalMzSm9SbFJSTDFvclNHbEJibTlVVXpWNGRraEJVVWR0VlRSMGQwcGpaR0pMZDJVclNFUjJNVGd3ZVdZS1VscEJUQ3R2ZFVGS1NEY3lZalZ4YW05WFZWSTBZWEZvUmtSUlMyOHdObFZJVFZwR1pGbFpaa0pMYzNWSWQxSlNRa1l6VlVkVU5WTnhOWFUyZERCUU5ncGhTeXQxUlZrMkszaEJiWE4wVGxOWVprNVJNakk0UjFkaWNWQTNRMUpzVTJJNFpIRXhTbVI2ZUZaSmIwTk5WRXBzYTJGaWFUQTVVVWR6Y2pRNE1UTXdDa3R2ZURaS2JsRjZXRTlvU0hOQ1dDdENhbFZ6WTBsSVZrMWhZakJVVUZadVQwaHdNbEpXV0ZOT1FuSkdSQzg0VTI1UmVsUnZibEZ2VWpSTFNqZDNiQzhLWkZObGFUQk5VMVJHWmpGeUNpMHRMUzB0UlU1RUlFTkZVbFJKUmtsRFFWUkZMUzB0TFMwSwpBUElfU0VSVkVSX1VSTD1odHRwczovLzQzMzY3MzEyMzFCMjBCNkQ0Mzg5ODVFRjIzRjVFQUUxLmdyNy51cy1lYXN0LTEuZWtzLmFtYXpvbmF3cy5jb20KL2V0Yy9la3MvYm9vdHN0cmFwLnNoIGVrcy1kZXYtdWUxIC0ta3ViZWxldC1leHRyYS1hcmdzICctLW5vZGUtbGFiZWxzPWVudj1kZXYsc2VsZi1tYW5hZ2VkLW5vZGU9dHJ1ZSxyZWdpb249dWUxLGs4c19uYW1lc3BhY2U9ZGV2ICAtLXJlZ2lzdGVyLXdpdGgtdGFpbnRzPWRldi1vbmx5PXRydWU6UHJlZmVyTm9TY2hlZHVsZScgLS1iNjQtY2x1c3Rlci1jYSAkQjY0X0NMVVNURVJfQ0EgLS1hcGlzZXJ2ZXItZW5kcG9pbnQgJEFQSV9TRVJWRVJfVVJMCiMgdGhpcyBpcyB0byBjb21wbGV0ZWx5IGJsb2NrIGFsbCBjb250YWluZXJzIHJ1bm5pbmcgb24gYSB3b3JrZXIgbm9kZSBmcm9tIHF1ZXJ5aW5nIHRoZSBpbnN0YW5jZSBtZXRhZGF0YSBzZXJ2aWNlIGZvciBhbnkgbWV0YWRhdGEgdG8gYXZvaWQgcG9kcyBmcm9tIHVzaW5nIG5vZGUncyBJQU0gaW5zdGFuY2UgcHJvZmlsZQojIHJlZjogaHR0cHM6Ly9kb2NzLmF3cy5hbWF6b24uY29tL2Vrcy9sYXRlc3QvdXNlcmd1aWRlL3Jlc3RyaWN0LWVjMi1jcmVkZW50aWFsLWFjY2Vzcy5odG1sCnl1bSBpbnN0YWxsIC15IGlwdGFibGVzLXNlcnZpY2VzOyBpcHRhYmxlcyAtLWluc2VydCBGT1JXQVJEIDEgLS1pbi1pbnRlcmZhY2UgZW5pKyAtLWRlc3RpbmF0aW9uIDE2OS4yNTQuMTY5LjI1NC8zMiAtLWp1bXAgRFJPUDsgaXB0YWJsZXMtc2F2ZSB8IHRlZSAvZXRjL3N5c2NvbmZpZy9pcHRhYmxlczsgc3lzdGVtY3RsIGVuYWJsZSAtLW5vdyBpcHRhYmxlczsKCiMgaW5zdGFsbCBJbnNwZWN0b3IgYWdlbnQKY3VybCAtTyBodHRwczovL2luc3BlY3Rvci1hZ2VudC5hbWF6b25hd3MuY29tL2xpbnV4L2xhdGVzdC9pbnN0YWxsOyBzdWRvIGJhc2ggaW5zdGFsbDsKCiMgaW5zdGFsbCBTU00gYWdlbnQKc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwczovL3MzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2FtYXpvbi1zc20tdXMtZWFzdC0xL2xhdGVzdC9saW51eF9hbWQ2NC9hbWF6b24tc3NtLWFnZW50LnJwbTsgc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGFtYXpvbi1zc20tYWdlbnQ7IHN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGFtYXpvbi1zc20tYWdlbnQ7Cgo="
      + vpc_security_group_ids = (known after apply)

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
          + cluster_workers_user_data                                   = "IyEvYmluL2Jhc2gKc2V0IC1lCkI2NF9DTFVTVEVSX0NBPUxTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJDVkVORFFXVXlaMEYzU1VKQlowbEpXaXRGTTFwVFJraERMMWwzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkR1ZFVlVUVUpGUjBFeFZVVUtRWGhOUzJFelZtbGFXRXAxV2xoU2JHTjZRV1ZHZHpCNVRYcEZkMDFxWjNoTmVsRXhUV3BrWVVaM01IcE5la1YzVFdwVmVFMTZWWGROYW1SaFRVSlZlQXBGZWtGU1FtZE9Wa0pCVFZSRGJYUXhXVzFXZVdKdFZqQmFXRTEzWjJkRmFVMUJNRWREVTNGSFUwbGlNMFJSUlVKQlVWVkJRVFJKUWtSM1FYZG5aMFZMQ2tGdlNVSkJVVVJKZEhKWGFFWlFkWGRDVkRFeVowVktkMm94Y1ZrMk1tb3hSWGwzY1hvNWVVSmpRVTFMVG1vckx6SXJWM2hVUkRoeWMxSmpVV2xZYVhvS2FEZDZRMmgzWW5SNlJXUTNiMWRaUmpWSU9FMUpXVkpUWkdnNVUxb3hiV1Z3UWpSV2JpdDFiRGhRYVhwYVkwOWxLelo2ZFU1SlpuTlZlRXcxVDFoSGJncDNNSFUxYlhaU2JsZEdjWGN6Um1reU9WZHlWMnRGTDBSalMzZzFWMDA1YzI5UGR5ODFTemhuTmtOeU4yb3djRE5rVVhkRldGQjRaemRyWTJvcmFtcHhDa2xMTUhvMk5HOUtZVkZqYUZKa2EzTlhibWc1VkdNeFdIYzVaMEZYV0ZSc2RISjBjRlZHZWpCQlFYRkpSbEZRTTBKMU5EQkVSakpyUzJZMGFtNXZVVWNLU25jcmFFVjVNMFZJZWxsdEsxQk5NMHRSUlc5NFoweHhhekp1Wld4WlR6QlVkV1YzTTJGT1dpOUNUM294WjBrMWR6TTVMM2RsTm5sQ2VqSlZWWGwzS3dwS2QyaHpOM2haYzBSTVRtRlRVbEV3TkhKU1l6VnBWMGN6THpseVFXZE5Ra0ZCUjJwWFZFSllUVUUwUjBFeFZXUkVkMFZDTDNkUlJVRjNTVU53UkVGUUNrSm5UbFpJVWsxQ1FXWTRSVUpVUVVSQlVVZ3ZUVUl3UjBFeFZXUkVaMUZYUWtKVVVpOVdkalJsYkd3M2FHdGlSV3QyVFdZdk5uWkdlRzhyYUdOVVFWWUtRbWRPVmtoU1JVVkVha0ZOWjJkd2NtUlhTbXhqYlRWc1pFZFdlazFCTUVkRFUzRkhVMGxpTTBSUlJVSkRkMVZCUVRSSlFrRlJRMmd3Y25kNlkxcGphQW80Y0hVNGVsaEdSbkp4UlVWeVdUZERNMWx4VUdaWFMybEJSVzlGWm0xYVlreEJXbVZ1VTJ4bU5uVTRSSFJhUzJkSWNXRm5RMHhPU1hWbVJVRXlialp0Q2xaVU5tNURiVVJDVFdoWU9UVnJlRFZ2WTFsalMzSm9SbFJSTDFvclNHbEJibTlVVXpWNGRraEJVVWR0VlRSMGQwcGpaR0pMZDJVclNFUjJNVGd3ZVdZS1VscEJUQ3R2ZFVGS1NEY3lZalZ4YW05WFZWSTBZWEZvUmtSUlMyOHdObFZJVFZwR1pGbFpaa0pMYzNWSWQxSlNRa1l6VlVkVU5WTnhOWFUyZERCUU5ncGhTeXQxUlZrMkszaEJiWE4wVGxOWVprNVJNakk0UjFkaWNWQTNRMUpzVTJJNFpIRXhTbVI2ZUZaSmIwTk5WRXBzYTJGaWFUQTVVVWR6Y2pRNE1UTXdDa3R2ZURaS2JsRjZXRTlvU0hOQ1dDdENhbFZ6WTBsSVZrMWhZakJVVUZadVQwaHdNbEpXV0ZOT1FuSkdSQzg0VTI1UmVsUnZibEZ2VWpSTFNqZDNiQzhLWkZObGFUQk5VMVJHWmpGeUNpMHRMUzB0UlU1RUlFTkZVbFJKUmtsRFFWUkZMUzB0TFMwSwpBUElfU0VSVkVSX1VSTD1odHRwczovLzQzMzY3MzEyMzFCMjBCNkQ0Mzg5ODVFRjIzRjVFQUUxLmdyNy51cy1lYXN0LTEuZWtzLmFtYXpvbmF3cy5jb20KL2V0Yy9la3MvYm9vdHN0cmFwLnNoIGVrcy1kZXYtdWUxIC0ta3ViZWxldC1leHRyYS1hcmdzICctLW5vZGUtbGFiZWxzPWVudj1kZXYsc2VsZi1tYW5hZ2VkLW5vZGU9dHJ1ZSxyZWdpb249dWUxLGs4c19uYW1lc3BhY2U9ZGV2ICAtLXJlZ2lzdGVyLXdpdGgtdGFpbnRzPWRldi1vbmx5PXRydWU6UHJlZmVyTm9TY2hlZHVsZScgLS1iNjQtY2x1c3Rlci1jYSAkQjY0X0NMVVNURVJfQ0EgLS1hcGlzZXJ2ZXItZW5kcG9pbnQgJEFQSV9TRVJWRVJfVVJMCiMgdGhpcyBpcyB0byBjb21wbGV0ZWx5IGJsb2NrIGFsbCBjb250YWluZXJzIHJ1bm5pbmcgb24gYSB3b3JrZXIgbm9kZSBmcm9tIHF1ZXJ5aW5nIHRoZSBpbnN0YW5jZSBtZXRhZGF0YSBzZXJ2aWNlIGZvciBhbnkgbWV0YWRhdGEgdG8gYXZvaWQgcG9kcyBmcm9tIHVzaW5nIG5vZGUncyBJQU0gaW5zdGFuY2UgcHJvZmlsZQojIHJlZjogaHR0cHM6Ly9kb2NzLmF3cy5hbWF6b24uY29tL2Vrcy9sYXRlc3QvdXNlcmd1aWRlL3Jlc3RyaWN0LWVjMi1jcmVkZW50aWFsLWFjY2Vzcy5odG1sCnl1bSBpbnN0YWxsIC15IGlwdGFibGVzLXNlcnZpY2VzOyBpcHRhYmxlcyAtLWluc2VydCBGT1JXQVJEIDEgLS1pbi1pbnRlcmZhY2UgZW5pKyAtLWRlc3RpbmF0aW9uIDE2OS4yNTQuMTY5LjI1NC8zMiAtLWp1bXAgRFJPUDsgaXB0YWJsZXMtc2F2ZSB8IHRlZSAvZXRjL3N5c2NvbmZpZy9pcHRhYmxlczsgc3lzdGVtY3RsIGVuYWJsZSAtLW5vdyBpcHRhYmxlczsKCiMgaW5zdGFsbCBJbnNwZWN0b3IgYWdlbnQKY3VybCAtTyBodHRwczovL2luc3BlY3Rvci1hZ2VudC5hbWF6b25hd3MuY29tL2xpbnV4L2xhdGVzdC9pbnN0YWxsOyBzdWRvIGJhc2ggaW5zdGFsbDsKCiMgaW5zdGFsbCBTU00gYWdlbnQKc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwczovL3MzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2FtYXpvbi1zc20tdXMtZWFzdC0xL2xhdGVzdC9saW51eF9hbWQ2NC9hbWF6b24tc3NtLWFnZW50LnJwbTsgc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGFtYXpvbi1zc20tYWdlbnQ7IHN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGFtYXpvbi1zc20tYWdlbnQ7Cgo="
        }
    }
```