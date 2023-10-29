variable "cluster_openid_connect_provider_arn" {
  description = "The ARN assigned by AWS for this provider."
  default     = ""
}

variable "cluster_openid_connect_provider_url" {
  description = "(Required) The URL of the identity provider. Corresponds to the iss claim."
  default     = ""
}