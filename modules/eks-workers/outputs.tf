################################################################################
# Node Security Group
################################################################################

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the node shared security group"
  value       = try(aws_security_group.node[0].arn, null)
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(aws_security_group.node[0].id, null)
}

################################################################################
# Self Managed Node Group
################################################################################

output "self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  value       = module.self_managed_node_group
}

# output "self_managed_node_groups_autoscaling_group_names" {
#   description = "List of the autoscaling group names created by self-managed node groups"
#   value       = compact([for group in module.self_managed_node_group : group.autoscaling_group_name])
# }

