# Region
aws_region = "us-west-2"

# Environment name
environment = "dev"

# EC2 instance types
backend_instance_type  = "t3.medium"
database_instance_type = "t3.medium"
frontend_instance_type = "t3.medium"

# Existing EC2 Key Pair name (must match exactly in AWS us-west-2)
key_name = "project1u"

# Existing S3 bucket (only needed if you are still creating an app bucket)
# If you're using this bucket ONLY for Terraform backend, you can remove this
s3_bucket_name = "amzn-proj0129-syn-bucket"
