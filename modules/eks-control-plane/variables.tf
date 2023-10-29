variable "region" {
  type        = string
  description = "AWS region"
}

variable "region_tag" {
  description = "AWS region tag"
  type        = map(any)

  default = {
    "us-east-1"    = "ue1"
    "us-west-1"    = "uw1"
    "eu-west-1"    = "ew1"
    "eu-central-1" = "ec1"
  }
}

variable "env" {
  type        = string
  description = "env"
}

# EKS
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
}

variable "enabled_cluster_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

