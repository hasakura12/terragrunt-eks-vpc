########################################
## CloudWatch Logs for EKS control plane logging
########################################
# this needs be created before EKS control plane, because default one with "expiration=Never" will be created if "enabled_cluster_log_types=true"
resource "aws_cloudwatch_log_group" "cluster" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
}