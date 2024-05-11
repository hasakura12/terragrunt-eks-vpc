########################################
## CloudWatch Logs for EKS control plane logging
########################################
output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.cluster.arn
}