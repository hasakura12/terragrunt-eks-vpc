################################################################################
# EKS Addons
# Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/main.tf#L378-L438
################################################################################
locals {
  create                        = true
  create_outposts_local_cluster = false
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
resource "aws_eks_addon" "this" {
  for_each = { for k, v in var.cluster_addons : k => v if !try(v.before_compute, false) && local.create && !local.create_outposts_local_cluster }

  cluster_name = var.cluster_name
  addon_name   = try(each.value.name, each.key)

  addon_version            = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  configuration_values     = try(each.value.configuration_values, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)

  timeouts {
    create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
    update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
    delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  }

  #   depends_on = [
  #     module.self_managed_node_group,
  #   ]

  tags = var.tags
}

resource "aws_eks_addon" "before_compute" {
  # Not supported on outposts
  for_each = { for k, v in var.cluster_addons : k => v if try(v.before_compute, false) && local.create && !local.create_outposts_local_cluster }

  cluster_name = var.cluster_name
  addon_name   = try(each.value.name, each.key)

  addon_version            = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  configuration_values     = try(each.value.configuration_values, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)

  timeouts {
    create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
    update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
    delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  }

  tags = var.tags
}

data "aws_eks_addon_version" "this" {
  for_each = { for k, v in var.cluster_addons : k => v if local.create && !local.create_outposts_local_cluster }

  addon_name         = try(each.value.name, each.key)
  kubernetes_version = var.cluster_version
  most_recent        = try(each.value.most_recent, null)
}
