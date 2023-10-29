## IRSA ##
resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json
  name               = "cluster_autoscaler"
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  description = local.cluster_autoscaler_iam_policy_description
  name        = local.cluster_autoscaler_iam_policy_name
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
}
