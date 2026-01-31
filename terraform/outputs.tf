output "website_bucket_name" {
  description = "S3 bucket name for website content"
  value       = aws_s3_bucket.website.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}

output "deploy_role_arn" {
  description = "ARN of the IAM role for GitHub Actions deploy"
  value       = aws_iam_role.deploy.arn
}

output "domain_name" {
  description = "Primary domain name"
  value       = var.domain_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
