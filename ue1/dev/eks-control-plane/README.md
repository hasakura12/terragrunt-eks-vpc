# Create EKS Control Plane
There are two ways to manage infrastructure (slower&complete, or faster&granular):

- **As a Single Layer**

Run this command to create infrastructure in a single layer (eks-control-plane):
```sh
$ cd ../eks-control-plane

$ terragrunt apply --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

# if dependent resources (vpc and eks-control-plane-logs) haven't been applied, you will get error below, then go to dependent module's path and terragrunt apply them before this module
ERRO[0002] /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block. 
ERRO[0002] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
```

- **All dependencies as a whole**

EKS-control-plane consists of multiple dependencies (vpc and eks-control-plane-logs).

`terragrunt run-all apply` will create all resources in one-go:
```sh
$ cd ../eks-control-plane
$ terragrunt run-all plan --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane depends on module /terragrunt-eks-vpc/ue1/dev/vpc, which is an external dependency outside of the current working directory. Should Terragrunt run this external dependency? Warning, if you say 'yes', Terragrunt will make changes in /terragrunt-eks-vpc/ue1/dev/vpc as well! (y/n) y
Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane depends on module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs, which is an external dependency outside of the current working directory. Should Terragrunt run this external dependency? Warning, if you say 'yes', Terragrunt will make changes in /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs as well! (y/n) y
INFO[0004] The stack at /terragrunt-eks-vpc/ue1/dev/eks-control-plane will be processed in the following order for command plan:
Group 1
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs
- Module /terragrunt-eks-vpc/ue1/dev/vpc

Group 2
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane

Initializing the backend...

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 4.0.2 for vpc...
- Installing hashicorp/aws v5.49.0...
- vpc in .terraform/modules/vpc

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v5.49.0...
- Installed hashicorp/aws v5.49.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
- Installed hashicorp/aws v5.49.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.vpc.aws_default_network_acl.this[0] will be created
  + resource "aws_default_network_acl" "this" {
      + arn                    = (known after apply)
      + default_network_acl_id = (known after apply)
      + id                     = (known after apply)
      + owner_id               = (known after apply)
      + tags                   = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
        }
      + tags_all               = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id                 = (known after apply)

      + egress {
          + action          = "allow"
          + from_port       = 0
          + ipv6_cidr_block = "::/0"
          + protocol        = "-1"
          + rule_no         = 101
          + to_port         = 0
        }
      + egress {
          + action     = "allow"
          + cidr_block = "0.0.0.0/0"
          + from_port  = 0
          + protocol   = "-1"
          + rule_no    = 100
          + to_port    = 0
        }

      + ingress {
          + action          = "allow"
          + from_port       = 0
          + ipv6_cidr_block = "::/0"
          + protocol        = "-1"
          + rule_no         = 101
          + to_port         = 0
        }
      + ingress {
          + action     = "allow"
          + cidr_block = "0.0.0.0/0"
          + from_port  = 0
          + protocol   = "-1"
          + rule_no    = 100
          + to_port    = 0
        }
    }

  # module.vpc.aws_default_route_table.default[0] will be created
  + resource "aws_default_route_table" "default" {
      + arn                    = (known after apply)
      + default_route_table_id = (known after apply)
      + id                     = (known after apply)
      + owner_id               = (known after apply)
      + route                  = (known after apply)
      + tags                   = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
        }
      + tags_all               = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id                 = (known after apply)

      + timeouts {
          + create = "5m"
          + update = "5m"
        }
    }

  # module.vpc.aws_default_security_group.this[0] will be created
  + resource "aws_default_security_group" "this" {
      + arn                    = (known after apply)
      + description            = (known after apply)
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
        }
      + tags_all               = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-default"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id                 = (known after apply)
    }

  # module.vpc.aws_eip.nat[0] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + arn                  = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + ptr_record           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1a"
        }
      + tags_all             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1a"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc                  = true
    }

  # module.vpc.aws_eip.nat[1] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + arn                  = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + ptr_record           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1b"
        }
      + tags_all             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1b"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc                  = true
    }

  # module.vpc.aws_internet_gateway.this[0] will be created
  + resource "aws_internet_gateway" "this" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps"
        }
      + tags_all = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc.aws_nat_gateway.this[0] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags                               = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1a"
        }
      + tags_all                           = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1a"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # module.vpc.aws_nat_gateway.this[1] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags                               = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1b"
        }
      + tags_all                           = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-us-east-1b"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # module.vpc.aws_route.private_nat_gateway[0] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route.private_nat_gateway[1] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route.public_internet_gateway[0] will be created
  + resource "aws_route" "public_internet_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + gateway_id             = (known after apply)
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route_table.private[0] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1a"
        }
      + tags_all         = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1a"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.private[1] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1b"
        }
      + tags_all         = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1b"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.public[0] will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public"
        }
      + tags_all         = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table_association.private[0] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private[1] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public[0] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public[1] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_subnet.private[0] will be created
  + resource "aws_subnet" "private" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.101.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1a"
          + "Tier"                                                                = "private"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + tags_all                                       = {
          + "App"                                                                 = "terragrunt-eks-vpc"
          + "Env"                                                                 = "dev"
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1a"
          + "Region"                                                              = "us-east-1"
          + "Region_Tag"                                                          = "ue1"
          + "Tier"                                                                = "private"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.private[1] will be created
  + resource "aws_subnet" "private" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.102.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1b"
          + "Tier"                                                                = "private"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + tags_all                                       = {
          + "App"                                                                 = "terragrunt-eks-vpc"
          + "Env"                                                                 = "dev"
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-private-us-east-1b"
          + "Region"                                                              = "us-east-1"
          + "Region_Tag"                                                          = "ue1"
          + "Tier"                                                                = "private"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.public[0] will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public-us-east-1a"
          + "Tier"                                                                = "public"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + tags_all                                       = {
          + "App"                                                                 = "terragrunt-eks-vpc"
          + "Env"                                                                 = "dev"
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public-us-east-1a"
          + "Region"                                                              = "us-east-1"
          + "Region_Tag"                                                          = "ue1"
          + "Tier"                                                                = "public"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.public[1] will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public-us-east-1b"
          + "Tier"                                                                = "public"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + tags_all                                       = {
          + "App"                                                                 = "terragrunt-eks-vpc"
          + "Env"                                                                 = "dev"
          + "Name"                                                                = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps-public-us-east-1b"
          + "Region"                                                              = "us-east-1"
          + "Region_Tag"                                                          = "ue1"
          + "Tier"                                                                = "public"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
          + "kubernetes.io/role/internal-elb"                                     = "1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_vpc.this[0] will be created
  + resource "aws_vpc" "this" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps"
        }
      + tags_all                             = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Name"       = "vpc-dev-ue1-terragrunt-eks-vpc-local-src-deps"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

Plan: 23 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + azs                                  = [
      + "us-east-1a",
      + "us-east-1b",
    ]
  + database_route_table_ids             = (known after apply)
  + database_subnet_arns                 = []
  + database_subnets                     = []
  + database_subnets_cidr_blocks         = []
  + igw_id                               = (known after apply)
  + nat_ids                              = [
      + (known after apply),
      + (known after apply),
    ]
  + nat_public_ips                       = [
      + (known after apply),
      + (known after apply),
    ]
  + natgw_ids                            = [
      + (known after apply),
      + (known after apply),
    ]
  + private_route_table_ids              = [
      + (known after apply),
      + (known after apply),
    ]
  + private_subnets                      = [
      + (known after apply),
      + (known after apply),
    ]
  + private_subnets_cidr_blocks          = [
      + "10.0.101.0/24",
      + "10.0.102.0/24",
    ]
  + public_route_table_ids               = [
      + (known after apply),
    ]
  + public_subnets                       = [
      + (known after apply),
      + (known after apply),
    ]
  + public_subnets_cidr_blocks           = [
      + "10.0.1.0/24",
      + "10.0.2.0/24",
    ]
  + vpc_cidr_block                       = "10.0.0.0/16"
  + vpc_enable_dns_hostnames             = true
  + vpc_enable_dns_support               = true
  + vpc_flow_log_cloudwatch_iam_role_arn = ""
  + vpc_flow_log_destination_arn         = ""
  + vpc_flow_log_destination_type        = "cloud-watch-logs"
  + vpc_id                               = (known after apply)
  + vpc_instance_tenancy                 = "default"
  + vpc_main_route_table_id              = (known after apply)
  + vpc_secondary_cidr_blocks            = []
╷
│ Warning: Argument is deprecated
│ 
│   with module.vpc.aws_eip.nat,
│   on .terraform/modules/vpc/main.tf line 1044, in resource "aws_eip" "nat":
│ 1044:   vpc = true
│ 
│ use domain attribute instead
│ 
│ (and 2 more similar warnings elsewhere)
╵

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
Releasing state lock. This may take a few moments...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_cloudwatch_log_group.cluster will be created
  + resource "aws_cloudwatch_log_group" "cluster" {
      + arn               = (known after apply)
      + id                = (known after apply)
      + log_group_class   = (known after apply)
      + name              = "/aws/eks/eks-dev-ue1-terragrunt-eks-vpc-/cluster"
      + name_prefix       = (known after apply)
      + retention_in_days = 7
      + skip_destroy      = false
      + tags_all          = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cloudwatch_log_group_arn = (known after apply)

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
Releasing state lock. This may take a few moments...

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/kubernetes v2.30.0...
- Installed hashicorp/kubernetes v2.30.0 (signed by HashiCorp)
- Installing hashicorp/aws v5.49.0...
- Installed hashicorp/aws v5.49.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
data.aws_iam_policy_document.assume_role_policy: Reading...
data.aws_caller_identity.this: Reading...
data.aws_iam_policy_document.assume_role_policy: Read complete after 0s [id=2764486067]
data.aws_caller_identity.this: Read complete after 0s [id=266981300450]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.aws_iam_policy_document.k8s_api_server_decryption will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "k8s_api_server_decryption" {
      + id            = (known after apply)
      + json          = (known after apply)
      + minified_json = (known after apply)

      + statement {
          + actions   = [
              + "kms:*",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow access for Key Administrators"

          + principals {
              + identifiers = [
                  + "arn:aws:iam::266981300450:root",
                ]
              + type        = "AWS"
            }
        }
      + statement {
          + actions   = [
              + "kms:Decrypt",
              + "kms:DescribeKey",
              + "kms:Encrypt",
              + "kms:GenerateDataKey*",
              + "kms:ReEncrypt*",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow service-linked role use of the CMK"

          + principals {
              + identifiers = [
                  + "arn:aws:iam::266981300450:root",
                  + (known after apply),
                ]
              + type        = "AWS"
            }
        }
      + statement {
          + actions   = [
              + "kms:CreateGrant",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
          + sid       = "Allow attachment of persistent resources"

          + condition {
              + test     = "Bool"
              + values   = [
                  + "true",
                ]
              + variable = "kms:GrantIsForAWSResource"
            }

          + principals {
              + identifiers = [
                  + (known after apply),
                ]
              + type        = "AWS"
            }
        }
    }

  # aws_eks_cluster.this will be created
  + resource "aws_eks_cluster" "this" {
      + arn                       = (known after apply)
      + certificate_authority     = (known after apply)
      + cluster_id                = (known after apply)
      + created_at                = (known after apply)
      + enabled_cluster_log_types = [
          + "api",
          + "audit",
          + "authenticator",
          + "controllerManager",
          + "scheduler",
        ]
      + endpoint                  = (known after apply)
      + id                        = (known after apply)
      + identity                  = (known after apply)
      + name                      = "eks-dev-ue1-terragrunt-eks-vpc-local-src-deps"
      + platform_version          = (known after apply)
      + role_arn                  = (known after apply)
      + status                    = (known after apply)
      + tags_all                  = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + version                   = "1.29"

      + encryption_config {
          + resources = [
              + "secrets",
            ]

          + provider {
              + key_arn = (known after apply)
            }
        }

      + vpc_config {
          + cluster_security_group_id = (known after apply)
          + endpoint_private_access   = false
          + endpoint_public_access    = true
          + public_access_cidrs       = (known after apply)
          + subnet_ids                = [
              + "subnet1",
              + "subnet2",
              + "subnet3",
              + "subnet4",
            ]
          + vpc_id                    = (known after apply)
        }
    }

  # aws_iam_role.cluster will be created
  + resource "aws_iam_role" "cluster" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "eks.amazonaws.com"
                        }
                      + Sid       = "EKSClusterAssumeRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "eks-cluster-control-plane"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy_attachment.EKSClusterPolicy will be created
  + resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      + role       = "eks-cluster-control-plane"
    }

  # aws_iam_role_policy_attachment.EKSVPCResourceController will be created
  + resource "aws_iam_role_policy_attachment" "EKSVPCResourceController" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
      + role       = "eks-cluster-control-plane"
    }

  # aws_kms_alias.k8s_secret will be created
  + resource "aws_kms_alias" "k8s_secret" {
      + arn            = (known after apply)
      + id             = (known after apply)
      + name           = "alias/cmk-dev-ue1-k8s-secret-dek"
      + name_prefix    = (known after apply)
      + target_key_arn = (known after apply)
      + target_key_id  = (known after apply)
    }

  # aws_kms_key.k8s_secret will be created
  + resource "aws_kms_key" "k8s_secret" {
      + arn                                = (known after apply)
      + bypass_policy_lockout_safety_check = false
      + customer_master_key_spec           = "SYMMETRIC_DEFAULT"
      + deletion_window_in_days            = 30
      + description                        = "Kms key used for encrypting K8s secret DEK (data encryption key)"
      + enable_key_rotation                = true
      + id                                 = (known after apply)
      + is_enabled                         = true
      + key_id                             = (known after apply)
      + key_usage                          = "ENCRYPT_DECRYPT"
      + multi_region                       = (known after apply)
      + policy                             = (known after apply)
      + rotation_period_in_days            = (known after apply)
      + tags_all                           = {
          + "App"        = "terragrunt-eks-vpc"
          + "Env"        = "dev"
          + "Region"     = "us-east-1"
          + "Region_Tag" = "ue1"
        }
    }

  # aws_security_group.cluster will be created
  + resource "aws_security_group" "cluster" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "eks-dev-ue1-terragrunt-eks-vpc-local-src-deps-cluster"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name"                                                                = "eks-dev-ue1-terragrunt-eks-vpc-local-src-deps-cluster"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
        }
      + tags_all               = {
          + "App"                                                                 = "terragrunt-eks-vpc"
          + "Env"                                                                 = "dev"
          + "Name"                                                                = "eks-dev-ue1-terragrunt-eks-vpc-local-src-deps-cluster"
          + "Region"                                                              = "us-east-1"
          + "Region_Tag"                                                          = "ue1"
          + "kubernetes.io/cluster/eks-dev-ue1-terragrunt-eks-vpc-local-src-deps" = "owned"
        }
      + vpc_id                 = "vpc-"
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_arn                        = (known after apply)
  + cluster_certificate_authority_data = (known after apply)
  + cluster_endpoint                   = (known after apply)
  + cluster_iam_role_arn               = (known after apply)
  + cluster_iam_role_name              = "eks-cluster-control-plane"
  + cluster_iam_role_unique_id         = (known after apply)
  + cluster_id                         = (known after apply)
  + cluster_name                       = "eks-dev-ue1-terragrunt-eks-vpc-local-src-deps"
  + cluster_oidc_issuer_url            = (known after apply)
  + cluster_platform_version           = (known after apply)
  + cluster_primary_security_group_id  = (known after apply)
  + cluster_secret_alias_arn           = (known after apply)
  + cluster_secret_id                  = (known after apply)
  + cluster_secret_kms_arn             = (known after apply)
  + cluster_security_group_arn         = (known after apply)
  + cluster_security_group_id          = (known after apply)
  + cluster_status                     = (known after apply)
  + cluster_version                    = "1.29"
```