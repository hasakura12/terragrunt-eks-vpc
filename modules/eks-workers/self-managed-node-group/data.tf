locals {
  # block_device_mappings = {
  #   xvda = {
  #     device_name = "/dev/sda1"
  #     ebs = {
  #       volume_size           = 20
  #       volume_type           = "gp3"
  #       encrypted             = true
  #       kms_key_id            = module.eks_node_ebs_kms_key.arn
  #       delete_on_termination = true
  #     }
  #   }
  # }

  #   appended_self_managed_node_group_list = [
  #       + {
  #           + ami_id                = "ami-084e4550ac5750077"
  #           + block_device_mappings = {
  #               + xvda = {
  #                   + device_name = "/dev/sda1"
  #                   + ebs         = {
  #                       + delete_on_termination = true
  #                       + encrypted             = true
  #                       + kms_key_id            = "asasa"
  #                       + volume_size           = 20
  #                       + volume_type           = "gp3"
  #                     }
  #                 }
  #             }
  #           + instance_type         = "m6g.large"
  #           + zone                  = "us-central1-b"
  #         },
  #       + {
  #           + ami_id                = "ami-084e4550ac5750077"
  #           + block_device_mappings = {
  #               + xvda = {
  #                   + device_name = "/dev/sda1"
  #                   + ebs         = {
  #                       + delete_on_termination = true
  #                       + encrypted             = true
  #                       + kms_key_id            = "asasa"
  #                       + volume_size           = 20
  #                       + volume_type           = "gp3"
  #                     }
  #                 }
  #             }
  #           + instance_type         = "r6g.large"
  #           + zone                  = "us-central1-a"
  #         },
  #     ]
  # refs: https://stackoverflow.com/questions/72770241/terraform-add-new-key-value-into-a-existing-list-of-map-from-another-map, https://stackoverflow.com/questions/69648226/terraform-what-is-this, https://www.reddit.com/r/Terraform/comments/xfraiv/merging_two_maps_into_new_map/
  #
  # append ami_id with arm64 architecture AMI arn to fix the following error:
  # │ Error: creating Auto Scaling Group (worker-group-dev-r6g-2023101907492172470000001b): ValidationError: You must use a valid fully-formed launch template. The architecture 'arm64' of the specified instance type does not match the architecture 'x86_64' of the specified AMI. Specify an instance type and an AMI that have matching architectures, and try again. You can use 'describe-instance-types' or 'describe-images' to discover the architecture of the instance type or AMI.
  # │       status code: 400, request id: 9e5024d8-3850-4721-bf0b-6df2c4200788
  # │ 
  # │   with module.eks_cluster.module.self_managed_node_group["dev-r6g"].aws_autoscaling_group.this[0],
  # │   on ../../../commons/container/eks/modules/self-managed-node-group/main.tf line 412, in resource "aws_autoscaling_group" "this":
  # │  412: resource "aws_autoscaling_group" "this" {"
  appended_self_managed_node_group_list = [
    for self_managed_node_group in var.self_managed_node_groups :
    merge(
      self_managed_node_group,
      {
        "ami_id" = data.aws_ami.arm64.id
      },
    )
  ]

  #   final_self_managed_node_groups   = {
  #       + dev-m6g = {
  #           + ami_id        = "arn:aws:ec2:us-east-1::image/ami-084e4550ac5750077"
  #           + instance_type = "r6g.large"
  #           + zone          = "us-central1-a"
  #         }
  #       + dev-r6g = {
  #           + ami_id        = "arn:aws:ec2:us-east-1::image/ami-084e4550ac5750077"
  #           + instance_type = "m6g.large"
  #           + zone          = "us-central1-b"
  #         }
  #     }
  # use zimap: https://developer.hashicorp.com/terraform/language/functions/zipmap, https://www.reddit.com/r/Terraform/comments/e89ago/iterator_in_forloop/
  final_self_managed_node_groups = zipmap(var.instance_types, local.appended_self_managed_node_group_list)
}

data "aws_ami" "arm64" {
  most_recent = true

  filter {
    name   = "architecture" # filterable keys. Ref: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
    values = ["arm64"]
  }
}