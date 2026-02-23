variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "project_name" {
  type        = string
  description = "Resource name prefix"
  default     = "aws-ebs-snapshot-cleaner"
}

variable "retention_days" {
  type        = number
  description = "Delete snapshots older than this many days"
  default     = 365
}

variable "dry_run" {
  type        = bool
  description = "If true, only logs actions"
  default     = true
}

variable "schedule_expression" {
  type        = string
  description = "EventBridge schedule expression"
  default     = "rate(1 day)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.40.0.0/16"
}
