data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "architecture" # filterable keys. Ref: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
    values = [var.architecture]
  }
}