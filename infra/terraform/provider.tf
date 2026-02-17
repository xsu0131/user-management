terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "amzn-proj0129-syn-bucket"
    key     = "user-management/dev/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
