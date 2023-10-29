########################################
## IAM role for EKS Cluster Autoscaler
########################################
output "cluster_autoscaler_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = aws_iam_role.cluster_autoscaler.name
}

output "cluster_autoscaler_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "cluster_autoscaler_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = aws_iam_role.cluster_autoscaler.id
}

########################################
## IAM policy for EKS Cluster Autoscaler
########################################
output "cluster_autoscaler_iam_policy_description" {
  description = "(Optional, Forces new resource) Description of the IAM policy."
  value       = aws_iam_policy.cluster_autoscaler_policy.description
}

output "cluster_autoscaler_iam_policy_name" {
  description = "(Optional, Forces new resource) The name of the policy. If omitted, Terraform will assign a random, unique name."
  value       = aws_iam_policy.cluster_autoscaler_policy.name
}

output "cluster_autoscaler_iam_policy_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name."
  value       = aws_iam_policy.cluster_autoscaler_policy.name_prefix
}

output "cluster_autoscaler_iam_policy_path" {
  description = "(Optional, default '/') Path in which to create the policy. See IAM Identifiers for more information."
  value       = aws_iam_policy.cluster_autoscaler_policy.path
}

output "cluster_autoscaler_iam_policy_policy" {
  description = "(Required) The policy document. This is a JSON formatted string. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide"
  value       = aws_iam_policy.cluster_autoscaler_policy.policy
}


########################################
## IAM policy attachment for EKS Cluster Autoscaler
########################################
output "cluster_autoscaler_iam_policy_attachment_role" {
  description = "(Required) - The name of the IAM role to which the policy should be applied"
  value       = aws_iam_role_policy_attachment.cluster_autoscaler.role
}

output "cluster_autoscaler_iam_policy_attachment_policy_arn" {
  description = "(Required) - The ARN of the policy you want to apply"
  value       = aws_iam_role_policy_attachment.cluster_autoscaler.policy_arn
}
