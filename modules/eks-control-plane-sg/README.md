# Expected Terraform Plan Outputs

```sh
Terraform will perform the following actions:

  # aws_security_group_rule.ingress_nodes_443 will be created
  + resource "aws_security_group_rule" "ingress_nodes_443" {
      + description              = "Node groups to cluster API"
      + from_port                = 443
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = "sg-06a2c34a2530a4c44"
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-07902d8ce6ad91df0"
      + to_port                  = 443
      + type                     = "ingress"
    }

  # aws_security_group_rule.ingress_nodes_ephemeral_ports_tcp will be created
  + resource "aws_security_group_rule" "ingress_nodes_ephemeral_ports_tcp" {
      + description              = "Nodes on ephemeral ports"
      + from_port                = 1025
      + id                       = (known after apply)
      + protocol                 = "tcp"
      + security_group_id        = "sg-06a2c34a2530a4c44"
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = "sg-07902d8ce6ad91df0"
      + to_port                  = 65535
      + type                     = "ingress"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_security_group_ingress_nodes_443_id                                  = (known after apply)
  + cluster_security_group_ingress_nodes_443_security_group_rule_id              = (known after apply)
  + node_security_group_ingress_nodes_ephemeral_ports_tcp_id                     = (known after apply)
  + node_security_group_ingress_nodes_ephemeral_ports_tcp_security_group_rule_id = (known after apply)
```