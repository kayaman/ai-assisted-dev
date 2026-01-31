# Setup Guide

## 0. First-time AWS Setup (no root for day-to-day use)

If you only have the root user, create an IAM user first and use it for all steps below.

### Create IAM user (one-time, as root)

1. Sign in to AWS Console as root
2. IAM → Users → **Create user**
3. User name: e.g. `terraform-admin`
4. **Next** → Attach policies directly → **AdministratorAccess**
5. **Next** → **Create user**

### Create access keys

1. Open the new user → Security credentials
2. **Create access key** → Command Line Interface (CLI) → Next → Create
3. Save **Access Key ID** and **Secret Access Key** securely

### Configure AWS CLI

Use the project name as the profile for consistency:

```bash
aws configure --profile ai-assisted-dev
# Access Key ID: <paste>
# Secret Access Key: <paste>
# Default region: us-east-1
```

Then use this profile for all Terraform and AWS CLI commands:

```bash
export AWS_PROFILE=ai-assisted-dev
```

Enable MFA on the root user and avoid using it for daily work.

---

## 1. Bootstrap Terraform State

Ensure `AWS_PROFILE=ai-assisted-dev` is set.

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

## 2. GitHub OIDC Provider (AWS)

GitHub Actions uses OIDC to assume an IAM role without storing credentials. Create the provider **once per AWS account**:

### Option A: AWS Console

1. IAM → Identity providers → Add provider
2. Provider type: **OpenID Connect**
3. Provider URL: `https://token.actions.githubusercontent.com`
4. Audience: `sts.amazonaws.com`

### Option B: AWS CLI

```bash
AWS_PROFILE=ai-assisted-dev aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### Option C: Bootstrap (optional)

With `AWS_PROFILE=ai-assisted-dev` set, bootstrap can create the provider:

```bash
terraform apply -var="create_oidc_provider=true"
```

## 3. Main Terraform

Create `terraform/terraform.tfvars` from the example. Ensure `AWS_PROFILE=ai-assisted-dev` is set, then:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## 4. GitHub Variables and Secrets

After `terraform apply`, sync outputs to GitHub (requires [gh CLI](https://cli.github.com/) authenticated):

```bash
./scripts/setup-github-vars.sh
```

With `--dry-run` to preview without changing anything:

```bash
./scripts/setup-github-vars.sh --dry-run
```

**Sets:**

| Name                 | Type   | Used by                            |
|----------------------|--------|-------------------------------------|
| AWS_DEPLOY_ROLE_ARN  | Secret | deploy.yaml, preview.yaml          |
| AWS_S3_BUCKET        | Var    | deploy.yaml, preview.yaml          |
| AWS_CLOUDFRONT_ID    | Var    | deploy.yaml                        |
| DOMAIN_NAME          | Var    | preview.yaml (preview URLs)        |
| AWS_REGION           | Var    | All AWS-related workflows       |

**Optional:** For Terraform plan/apply in CI, create an IAM role with Terraform permissions and set `AWS_TERRAFORM_ROLE_ARN` as a secret.

**Manual alternative:**

```bash
cd terraform
terraform output -raw deploy_role_arn   # → GitHub secret AWS_DEPLOY_ROLE_ARN
terraform output -raw website_bucket_name
terraform output -raw cloudfront_distribution_id
terraform output -raw domain_name
terraform output -raw aws_region
```
