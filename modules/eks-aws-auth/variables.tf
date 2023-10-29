variable "aws_account_id" {
  description = "AWS account ID"
}

variable "terraform_role_name" {
  type        = string
  description = "Terraform IAM role name"
}

variable "developer_role_name" {
  type        = string
  description = "Developer IAM role name"
}

variable "full_admin_role_name" {
  type        = string
  description = "Full Admin IAM role name"
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of AWS account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}