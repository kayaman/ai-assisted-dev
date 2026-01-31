variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ai-assisted-dev"
}

variable "aws_region" {
  description = "AWS region for state bucket"
  type        = string
  default     = "us-east-1"
}
