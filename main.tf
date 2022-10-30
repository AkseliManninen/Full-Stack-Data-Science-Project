provider "aws" {
    region = "eu-west-1"     # Ireland
}

# S3 bucket
resource "aws_s3_bucket" "electricity-data-bucket" { # resource type, resource name used in the code
  bucket = "electricity-data-bucket"
}

# terraform init > terraform plan > terraform apply