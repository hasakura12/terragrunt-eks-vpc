# dependencies
variable "cluster_version" {
  description = "Kubernetes cluster version - used to lookup default AMI ID if one is not provided"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets for cluster worker nodes"
  default     = []
}
