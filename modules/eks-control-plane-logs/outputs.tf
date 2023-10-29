########################################
## CloudWatch Logs for EKS control plane logging
########################################
output "cluster_cloudwatch_logs_arn" {
  value = aws_cloudwatch_log_group.cluster.arn
}