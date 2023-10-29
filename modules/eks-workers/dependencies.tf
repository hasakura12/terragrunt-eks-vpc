variable "cluster_version" {
  description = "Kubernetes cluster version - used to lookup default AMI ID if one is not provided"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  default     = ""
}

variable "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the cluster"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets for cluster worker nodes"
  default     = []
}