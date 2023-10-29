locals {
  aws_auth_configmap_data = {
    mapRoles = yamlencode(concat(var.aws_auth_roles, [
      {
        rolearn  = "arn:aws:iam::${var.aws_account_id}:role/${var.terraform_role_name}"
        username = "k8s_terraform_builder"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.aws_account_id}:role/${var.developer_role_name}"
        username = "k8s-developer"
        groups   = ["k8s-developer"]
      },
      {
        rolearn  = "arn:aws:iam::${var.aws_account_id}:role/${var.full_admin_role_name}"
        username = "k8s_admin"
        groups   = ["system:masters"]
      },
      ]
    ))
    mapUsers    = yamlencode(var.aws_auth_users)
    mapAccounts = yamlencode(var.aws_auth_accounts)
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  lifecycle {
    # We are ignoring the data here since we will manage it with the resource below
    # This is only intended to be used in scenarios where the configmap does not exist
    ignore_changes = [data, metadata[0].labels, metadata[0].annotations]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  depends_on = [
    # Required for instances where the configmap does not exist yet to avoid race condition
    kubernetes_config_map.aws_auth,
  ]
}