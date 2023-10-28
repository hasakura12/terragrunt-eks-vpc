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

inputs = {
  # override _envcommon/eks-workers.hcl 
  instance_types  = ["c1.medium"] #, "m6g.large"]
  self_managed_node_groups = {
    "c1.medium" = {
      name          = "${local.env}-c1medium"
      instance_type = "c1.medium" # since we are using AWS-VPC-CNI, allocatable pod IPs are defined by instance size: https://docs.google.com/spreadsheets/d/1MCdsmN7fWbebscGizcK6dAaPGS-8T_dYxWp0IdwkMKI/edit#gid=1549051942, https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
      max_size      = 1
      desired_size  = 1 # this will be ignored if cluster autoscaler is enabled: asg_desired_capacity: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md#notes

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

      tags = {
        "self-managed-node"                 = "true"
        "k8s.io/cluster-autoscaler/enabled" = "true" # need this tag so clusterautoscaler auto-discovers node group: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md
        "k8s_namespace"                     = "${local.env}"
      }
    },
  }
}