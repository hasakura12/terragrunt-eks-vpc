variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_log_retention_in_days" {
  default     = 90
  description = "Number of days to retain log events. Default retention - 90 days."
  type        = number
}