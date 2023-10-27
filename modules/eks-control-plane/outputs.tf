################################################################################
# EKS Cluster
################################################################################
output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "eks_cluster_id" {
  description = "The id of the EKS cluster."
  value       = aws_eks_cluster.this.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.this.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.this.version
}

output "eks_cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = aws_eks_cluster.this.platform_version
}

output "eks_cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = aws_eks_cluster.this.status
}

########################################
## IAM role for EKS Cluster Control Plane
########################################
output "eks_cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "eks_cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "eks_cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = aws_iam_role.cluster.id
}

########################################
## KMS for K8s secret's DEK (data encryption key) encryption
########################################
output "eks_secret_kms_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_key.k8s_secret.arn
}

output "eks_secret_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_alias.k8s_secret.arn
}

output "eks_secret_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.k8s_secret.id
}

########################################
## CloudWatch Logs for EKS control plane logging
########################################
output "eks_cluster_cloudwatch_logs_arn" {
  value = aws_cloudwatch_log_group.cluster.arn
}