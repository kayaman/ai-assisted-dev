#!/usr/bin/env bash
# Set GitHub Actions variables and secrets from Terraform outputs.
# Prerequisites: gh CLI installed and authenticated, terraform apply completed.
# Usage: ./scripts/setup-github-vars.sh [--dry-run]

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_DIR="$REPO_ROOT/terraform"
DRY_RUN=false

for arg in "$@"; do
	case $arg in
		--dry-run) DRY_RUN=true ;;
	esac
done

if ! command -v gh &>/dev/null; then
	echo "Error: gh CLI is required. Install from https://cli.github.com/" >&2
	exit 1
fi

if ! gh auth status &>/dev/null; then
	echo "Error: gh CLI is not authenticated. Run: gh auth login" >&2
	exit 1
fi

cd "$TERRAFORM_DIR"
if ! terraform output -raw website_bucket_name &>/dev/null; then
	echo "Error: Run 'terraform init' and 'terraform apply' in $TERRAFORM_DIR first" >&2
	exit 1
fi

BUCKET=$(terraform output -raw website_bucket_name)
DIST_ID=$(terraform output -raw cloudfront_distribution_id)
ROLE_ARN=$(terraform output -raw deploy_role_arn)
DOMAIN=$(terraform output -raw domain_name)
REGION=$(terraform output -raw aws_region)

set_output() {
	local name="$1"
	local value="$2"
	if $DRY_RUN; then
		echo "[dry-run] would set variable: $name"
	else
		gh variable set "$name" --body "$value"
		echo "Set variable: $name"
	fi
}

set_secret() {
	local name="$1"
	local value="$2"
	if $DRY_RUN; then
		echo "[dry-run] would set secret: $name"
	else
		echo "$value" | gh secret set "$name"
		echo "Set secret: $name"
	fi
}

echo "Setting GitHub repository variables and secrets..."
set_output "AWS_S3_BUCKET" "$BUCKET"
set_output "AWS_CLOUDFRONT_ID" "$DIST_ID"
set_output "DOMAIN_NAME" "$DOMAIN"
set_output "AWS_REGION" "$REGION"
set_secret "AWS_DEPLOY_ROLE_ARN" "$ROLE_ARN"

echo "Done. Optionally set AWS_TERRAFORM_ROLE_ARN for Terraform plan/apply workflows."
