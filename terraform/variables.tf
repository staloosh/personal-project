variable "aws_region" {
  description = "AWS region in which resources will be create"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deploy environment"
}

variable "app" {
  type        = string
  description = "Application name"
}