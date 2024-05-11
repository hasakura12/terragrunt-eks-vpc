# Create EKS Control Plane: Local Source Remote Dependencies
There are two ways to manage infrastructure (slower&complete, or faster&granular):

- **As a Single Layer**

Run this command to create infrastructure in a single layer (eks-control-plane):
```sh
$ cd /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps

$ terragrunt apply --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

# if dependent resources (vpc and eks-control-plane-logs) haven't been applied, you will get error below, then go to dependent module's path and terragrunt apply them before this module
ERRO[0002] /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs/terragrunt.hcl is a dependency of /terragrunt-eks-vpc/ue1/dev/eks-control-plane/terragrunt.hcl but detected no outputs. Either the target module has not been applied yet, or the module has no outputs. If this is expected, set the skip_outputs flag to true on the dependency block. 
ERRO[0002] Unable to determine underlying exit code, so Terragrunt will exit with error code 1 
```

- **All dependencies as a whole**

EKS-control-plane consists of multiple dependencies (vpc and eks-control-plane-logs).

`terragrunt run-all apply` will create all resources in one-go:
```sh
$ cd ../eks-control-plane
$ terragrunt run-all plan --terragrunt-source-update --terragrunt-download-dir .terragrunt-cache

Group 1
- Module /terragrunt-eks-vpc/ue1/dev/aws-data
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-logs-local-src-remote-deps
- Module /terragrunt-eks-vpc/ue1/dev/iam-roles-remote-source

Group 2
- Module /terragrunt-eks-vpc/ue1/dev/vpc-remote-source

Group 3
- Module /terragrunt-eks-vpc/ue1/dev/eks-control-plane-local-src-remote-deps
 
Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) y
```