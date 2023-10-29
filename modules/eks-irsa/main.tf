################################################################################
# IRSA
# Note - this is different from EKS identity provider
# Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/main.tf#L218-L242
################################################################################
data "tls_certificate" "this" {
  url = var.cluster_oidc_issuer_url #aws_eks_cluster.this[0].identity[0].oidc[0].issuer
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#enabling-iam-roles-for-service-accounts
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = var.cluster_oidc_issuer_url

  tags = merge(
    { Name = "${var.cluster_name}-eks-irsa" },
    var.tags
  )
}