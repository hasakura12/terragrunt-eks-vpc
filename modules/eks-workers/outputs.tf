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

########################################
## KMS for EKS node's EBS volume
########################################
output "cluster_workers_ebs_kms_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_key.eks_worker_ebs.arn
}

output "cluster_workers_ebs_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_alias.eks_worker_ebs.arn
}

output "cluster_workers_ebs_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.eks_worker_ebs.id
}
