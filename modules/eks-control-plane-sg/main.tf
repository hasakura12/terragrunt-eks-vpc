# ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/main.tf#L165-L174
resource "aws_security_group_rule" "ingress_nodes_443" {
  type                     = "ingress"
  description              = "Node groups to cluster API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.node_security_group_id
  security_group_id        = var.cluster_security_group_id
}

# ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf#L78-L86
# WARNING: needs this to allow kubeseal to work. Ref: https://github.com/bitnami-labs/sealed-secrets/issues/699#issuecomment-1064424553
resource "aws_security_group_rule" "ingress_nodes_ephemeral_ports_tcp" {
  type                     = "ingress"
  description              = "Nodes on ephemeral ports"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.node_security_group_id
  security_group_id        = var.cluster_security_group_id
}