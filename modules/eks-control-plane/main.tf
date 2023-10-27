resource "aws_eks_cluster" "this" {
  name    = var.cluster_name
  version = var.cluster_version

  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids             = var.private_subnets
    endpoint_public_access = var.cluster_endpoint_public_access
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.k8s_secret.arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups
  depends_on = [
    aws_iam_role_policy_attachment.EKSClusterPolicy,
    aws_iam_role_policy_attachment.EKSVPCResourceController,
    aws_cloudwatch_log_group.cluster,
  ]
}

########################################
## IAM role for EKS Cluster Control Plane
########################################
resource "aws_iam_role" "cluster" {
  name               = "eks-cluster-control-plane"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "EKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

################################################################################
# Cluster Security Group
# Defaults follow https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
################################################################################
resource "aws_security_group" "cluster" {
  name   = "${var.cluster_name}-cluster"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

# create this in EKS worker group module
# resource "aws_security_group_rule" "ingress_nodes_443" {
#   type        = "ingress"
#   description = "Node groups to cluster API"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   #   cidr_blocks       = aws_vpc.example.cidr_block
#   source_security_group_id = var.node_security_group # dependency
#   security_group_id        = aws_security_group.cluster.id
# }

# # create this in EKS worker group module
# resource "aws_security_group_rule" "ingress_nodes_ephemeral_ports_tcp" {
#   type        = "ingress"
#   description = "Nodes on ephemeral ports"
#   from_port   = 1025
#   to_port     = 65535
#   protocol    = "tcp"
#   #   cidr_blocks       = aws_vpc.example.cidr_block
#   source_security_group_id = var.node_security_group # dependency
#   security_group_id        = aws_security_group.cluster.id
# }


########################################
## KMS for K8s secret's DEK (data encryption key) encryption
########################################
resource "aws_kms_key" "k8s_secret" {

  description             = local.k8s_secret_kms_key_description
  deletion_window_in_days = local.k8s_secret_kms_key_deletion_window_in_days
  policy                  = data.aws_iam_policy_document.k8s_api_server_decryption.json
  enable_key_rotation     = true #var.enable_key_rotation
}

resource "aws_kms_alias" "k8s_secret" {
  name          = local.k8s_secret_kms_key_name
  target_key_id = aws_kms_key.k8s_secret.key_id
}

########################################
## CloudWatch Logs for EKS control plane logging
########################################
resource "aws_cloudwatch_log_group" "cluster" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
}