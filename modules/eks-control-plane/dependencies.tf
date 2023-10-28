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