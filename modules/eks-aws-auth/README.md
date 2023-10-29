# Expected Terraform Plan Outputs

```sh
Terraform will perform the following actions:

  # kubernetes_config_map.aws_auth will be created
  + resource "kubernetes_config_map" "aws_auth" {
      + data = {
          + "mapAccounts" = jsonencode([])
          + "mapRoles"    = <<-EOT
                - "groups":
                  - "system:masters"
                  "rolearn": "arn:aws:iam::266981300450:role/Terraform"
                  "username": "k8s_terraform_builder"
                - "groups":
                  - "k8s-developer"
                  "rolearn": "arn:aws:iam::266981300450:role/Developer"
                  "username": "k8s-developer"
                - "groups":
                  - "system:masters"
                  "rolearn": "arn:aws:iam::266981300450:role/FullAdmin"
                  "username": "k8s_admin"
            EOT
          + "mapUsers"    = jsonencode([])
        }
      + id   = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "aws-auth"
          + namespace        = "kube-system"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_config_map_v1_data.aws_auth will be created
  + resource "kubernetes_config_map_v1_data" "aws_auth" {
      + data          = {
          + "mapAccounts" = jsonencode([])
          + "mapRoles"    = <<-EOT
                - "groups":
                  - "system:masters"
                  "rolearn": "arn:aws:iam::266981300450:role/Terraform"
                  "username": "k8s_terraform_builder"
                - "groups":
                  - "k8s-developer"
                  "rolearn": "arn:aws:iam::266981300450:role/Developer"
                  "username": "k8s-developer"
                - "groups":
                  - "system:masters"
                  "rolearn": "arn:aws:iam::266981300450:role/FullAdmin"
                  "username": "k8s_admin"
            EOT
          + "mapUsers"    = jsonencode([])
        }
      + field_manager = "Terraform"
      + force         = true
      + id            = (known after apply)

      + metadata {
          + name      = "aws-auth"
          + namespace = "kube-system"
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

# Test k8s aws-auth configmap is created properly

```sh
$ k get cm -n kube-system aws-auth -o yaml
apiVersion: v1
data:
  mapAccounts: |
    - "777777777777"
    - "888888888888"
  mapRoles: |
    - "groups":
      - "system:masters"
      "rolearn": "arn:aws:iam::266981300450:role/Terraform"
      "username": "k8s_terraform_builder"
    - "groups":
      - "k8s-developer"
      "rolearn": "arn:aws:iam::266981300450:role/Developer"
      "username": "k8s-developer"
    - "groups":
      - "system:masters"
      "rolearn": "arn:aws:iam::266981300450:role/FullAdmin"
      "username": "k8s_admin"
  mapUsers: |
    - "groups":
      - "system:masters"
      "userarn": "arn:aws:iam::266981300450:user/dummy-admin-user"
      "username": "dummy-admin-user"
    - "groups":
      - "system:viewers"
      "userarn": "arn:aws:iam::266981300450}:user/dummy-viewer-user"
      "username": "dummy-viewer-user"
immutable: false
kind: ConfigMap
metadata:
  creationTimestamp: "2023-10-29T07:07:29Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "24641"
  uid: 8314cece-29a8-473c-acdb-2f15408c0da1
```