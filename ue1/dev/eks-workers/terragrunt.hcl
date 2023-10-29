# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-workers.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.env
}

# explicitly define dependency. Ref: https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependencies {
  paths = ["../vpc", "../eks-control-plane", "../eks-workers-ebs-encryption", "../eks-workers-ami-arm64"]
}

dependency "eks-workers-ami-arm64" {
  config_path = "../eks-workers-ami-arm64"

  mock_outputs = {
    ami_id = "dummy"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  mock_outputs_merge_strategy_with_state  = "shallow" # merge the mocked outputs and the state outputs
}

inputs = {
  # override _envcommon/eks-workers.hcl 
  self_managed_node_groups = {
    "c1.medium" = {
      name          = "${local.env}-c1medium"
      instance_type = "c1.medium" # since we are using AWS-VPC-CNI, allocatable pod IPs are defined by instance size: https://docs.google.com/spreadsheets/d/1MCdsmN7fWbebscGizcK6dAaPGS-8T_dYxWp0IdwkMKI/edit#gid=1549051942, https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
      # ami_id        = dependency.eks-workers-ami-arm64.outputs.aws_ami_id
      max_size     = 1
      desired_size = 1 # this will be ignored if cluster autoscaler is enabled: asg_desired_capacity: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md#notes

      user_data_template_path  = "templates/linux_user_data.tpl"
      post_bootstrap_user_data = <<-EOT
      # this is to completely block all containers running on a worker node from querying the instance metadata service for any metadata to avoid pods from using node's IAM instance profile
      # ref: https://docs.aws.amazon.com/eks/latest/userguide/restrict-ec2-credential-access.html
      yum install -y iptables-services; iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP; iptables-save | tee /etc/sysconfig/iptables; systemctl enable --now iptables;

      # install Inspector agent
      curl -O https://inspector-agent.amazonaws.com/linux/latest/install; sudo bash install;

      # install SSM agent
      sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm; sudo systemctl enable amazon-ssm-agent; sudo systemctl start amazon-ssm-agent;

      EOT
      bootstrap_extra_args     = "--kubelet-extra-args '--node-labels=env=${local.env},self-managed-node=true,region=ue1,k8s_namespace=${local.env}  --register-with-taints=${local.env}-only=true:PreferNoSchedule'" # for self-managed nodes, taints and labels work only with extra-arg, not ASG tags. Ref: https://aws.amazon.com/blogs/opensource/improvements-eks-worker-node-provisioning/

      block_device_mappings = {
        root = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            encrypted             = true
            kms_key_id            = dependency.eks-workers-ebs-encryption.outputs.cluster_workers_ebs_kms_arn
            delete_on_termination = true
          }
        }
      }

      tags = {
        "self-managed-node"                 = true
        "k8s_namespace"                     = local.env
      }
    },
  }

  # Extend node-to-node security group rules
  # WARNING: need this for metrics-server to work, as well as istio ingress/egress's readiness to work at http://:15021/healthz/ready. Ref: https://github.com/kubernetes-sigs/metrics-server/issues/1024#issuecomment-1124870217
  # ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf#L98-L117
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    },
    ingress_cluster_api_ephemeral_ports_tcp = {
      description                   = "Cluster API to K8S services running on nodes"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    },
  }
}