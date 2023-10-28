# for EBS encrypt/decrypt IAM policy
variable "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  default     = ""
}