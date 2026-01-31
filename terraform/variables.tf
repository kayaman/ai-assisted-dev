variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ai-assisted-dev"
}

variable "domain_name" {
  description = "Primary domain name (e.g. ai-assisted.dev)"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID for the domain"
  type        = string
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "ai-assisted-dev"
}

variable "github_branch" {
  description = "GitHub branch for deploy and preview"
  type        = string
  default     = "main"
}

