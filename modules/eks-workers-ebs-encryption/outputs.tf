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