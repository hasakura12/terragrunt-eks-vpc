variable "cluster_autoscaler_service_account_namespace" {
  description = "K8s namespace under which service account exists"
  default     = ""
}

variable "cluster_autoscaler_service_account_name" {
  description = "K8s service account (on behalf of pods) to allow assuming AWS IAM role through OIDC via AWS STS"
  default     = ""
}