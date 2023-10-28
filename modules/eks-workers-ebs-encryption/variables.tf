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