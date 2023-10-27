# terragrunt-eks-vpc

```sh
brew install tgenv

tgenv install 0.48.0
```

# Develop Locally
```sh
pwd 
terragrunt-eks-vpc/dev/ue1/dev/rds

# terragrunt plan --terragrunt-source <LOCAL_PATH_OF_MODULE>
terragrunt plan --terragrunt-source ../../../../modules/rds/

# or
TERRAGRUNT_SOURCE=LOCAL_PATH_OF_MODULE
terragrunt plan
```


## Linting & Git Pre Commit Hooks using Husky
Ref: https://www.npmjs.com/package/husky

```sh
brew install npm
npm install husky --save-dev

npm pkg set scripts.prepare="husky install"
npm run prepare

touch .husky/pre-commit
```

Edit .husky/pre-commit file for linting and running tests 
```sh
. "$(dirname -- "$0")/_/husky.sh"

# run terraform fmt
terraform fmt --recursive
terraform validate

# run other smoke or acceptance tests etc
```