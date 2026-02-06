variable "region" {
  type    = string
  default = "us-west-2"
}

variable "admin_cidr" {
  description = "Your public IP in CIDR format"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
