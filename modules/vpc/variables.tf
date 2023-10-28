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

variable "name" {
  type        = string
  description = "Name of the VPC you wish to create"
}

variable "cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of AWS Availablity Zones"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet cidrs"
}

variable "intra_subnets" {
  type        = list(string)
  description = "List of intra subnet cidrs"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet cidrs"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether or not to enable the NAT Gateway"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether or not to use a single nat gateway as opposed to one per subnet"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether or not to enable DNS Hostnames in/on the VPC"
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Whether or not to enable a VPN Gateway"
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags for private subnets"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags for public subnets"
}