variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "backend_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "database_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "frontend_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "s3_bucket_name" {
  type = string
}

variable "key_name" {
  type    = string
  default = "my-key-pair"
}

variable "environment" {
  type    = string
  default = "dev"
}
