locals {
  ## cluster_autoscaler_iam_role ##
  cluster_autoscaler_iam_role_name = "EKSClusterAutoscaler"

  ## cluster_autoscaler_iam_policy ##
  cluster_autoscaler_iam_policy_description = "EKS cluster-autoscaler policy"
  cluster_autoscaler_iam_policy_name        = "${local.cluster_autoscaler_iam_role_name}Policy"
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#enabling-iam-roles-for-service-accounts
data "aws_iam_policy_document" "cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.cluster_autoscaler_service_account_namespace}:${var.cluster_autoscaler_service_account_name}"]
    }

    principals {
      identifiers = [var.cluster_openid_connect_provider_arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    # limit who can assume the role
    # ref: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html
    # ref: https://www.terraform.io/docs/providers/aws/r/eks_cluster.html#enabling-iam-roles-for-service-accounts

    # [FIXED by using correct tag] ISSUE with below: SetDesiredCapacity operation: User: arn:aws:sts::202536423779:assumed-role/EKSClusterAutoscaler/botocore-session-1588872862 is not authorized to perform: autoscaling:SetDesiredCapacity on resource: arn:aws:autoscaling:us-east-1:202536423779:autoScalingGroup:b44f55c0-a6a9-4689-8651-7a72b7c6300a:autoScalingGroupName/eks-ue1-prod-peerwell-api-infra-worker-group-staging-120200507173038542300000005
    # remove this as we have two EKS cluster
    # condition {
    #   test     = "StringEquals"
    #   variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.cluster_id}"
    #   values   = ["shared"]
    # }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }

  # WARNING: the latest CA spits this error "Failed to generate AWS EC2 Instance Types: UnauthorizedOperation: You are not authorized to perform this operation."
  # Ref: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#full-cluster-autoscaler-features-policy-recommended
  statement {
    sid    = "newPolicies"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeScalingActivities",
      "ec2:DescribeInstanceTypes",
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]
  }
}
