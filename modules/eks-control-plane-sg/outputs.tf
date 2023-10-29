output "cluster_security_group_ingress_nodes_443_id" {
  description = "ID of the security group rule."
  value       = aws_security_group_rule.ingress_nodes_443.id
}
output "cluster_security_group_ingress_nodes_443_security_group_rule_id" {
  description = "If the aws_security_group_rule resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty."
  value       = aws_security_group_rule.ingress_nodes_443.security_group_rule_id
}

output "node_security_group_ingress_nodes_ephemeral_ports_tcp_id" {
  description = "ID of the security group rule."
  value       = aws_security_group_rule.ingress_nodes_ephemeral_ports_tcp.id
}
output "node_security_group_ingress_nodes_ephemeral_ports_tcp_security_group_rule_id" {
  description = "If the aws_security_group_rule resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty."
  value       = aws_security_group_rule.ingress_nodes_ephemeral_ports_tcp.security_group_rule_id
}