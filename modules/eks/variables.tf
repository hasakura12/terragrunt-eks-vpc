variable "name" {
  type        = string
  description = "VPC name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Whether or not to enable public access to the cluster's api endpoint"
}

variable "create_cluster_security_group" {
  type        = bool
  description = "Whether or not to create a cluster security group"
}

variable "create_node_security_group" {
  type        = bool
  description = "Whether or not to create a node security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnets for cluster worker nodes"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}