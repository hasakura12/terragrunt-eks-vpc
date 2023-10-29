# dependencies
variable "vpc_id" {
  type        = string
  description = "VPC ID for the cluster"
  default     = ""
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnets for cluster worker nodes"
  default     = []
}

variable "cluster_cloudwatch_logs_arn" {
  default = ""
}