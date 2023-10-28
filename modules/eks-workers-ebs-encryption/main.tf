########################################
## KMS for EKS node's EBS volume
########################################
resource "aws_kms_key" "eks_worker_ebs" {

  description             = local.eks_node_ebs_kms_key_description
  deletion_window_in_days = local.eks_node_ebs_kms_key_deletion_window_in_days
  policy                  = data.aws_iam_policy_document.ebs_decryption.json
  enable_key_rotation     = true #var.enable_key_rotation
}

resource "aws_kms_alias" "eks_worker_ebs" {
  name          = local.eks_node_ebs_kms_key_name
  target_key_id = aws_kms_key.eks_worker_ebs.key_id
}