variable "cluster_security_group_id" {
  description = "ID of the cluster security group"
  default     = "sg-"
}

variable "node_security_group_id" {
  description = "ID of the node shared security group"
  default     = "sg-"
}