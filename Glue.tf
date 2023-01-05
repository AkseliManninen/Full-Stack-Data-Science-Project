# This file is used for creating Glue crawlers, jobs, tables and permissions

# Creates an IAM role for Glue
# Used for S3 and RDS MySQL crawlers, creating Glue tables, Glue Job between S3 and RDS, creating Logs
resource "aws_iam_role" "iam_role_for_glue" {
  name = "iam_role_for_glue"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Creates an IAM policy for Glue, connected with iam_role_for_glue
resource "aws_iam_policy" "glue_policy" {
  name = "glue_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Connects the Glue policy to the Glue role
resource "aws_iam_policy_attachment" "attach_glue_policy" {
  name       = "attach_crawler_policy"
  policy_arn = aws_iam_policy.glue_policy.arn
  roles      = [aws_iam_role.iam_role_for_glue.name]
}

# Establishs a Glue database for S3
resource "aws_glue_catalog_database" "s3_glue_database" {
  name = "s3_glue_database"
}

# Creates a Glue crawler S3 to Glue
resource "aws_glue_crawler" "s3_crawler" {
  database_name = aws_glue_catalog_database.s3_glue_database.name
  name          = "s3_crawler"
  role          = aws_iam_role.iam_role_for_glue.arn

  s3_target {
    path = "s3://${aws_s3_bucket.electricity-data-bucket.bucket}"
  }
}

# Creates a S3 bucket for stroring Glue scripts
resource "aws_s3_bucket" "script-bucket" { # resource type, resource name used in the code
  bucket = "aws-glue-assets-065739622999-eu-west-1"
}

# Creating a Glue python job for moving data from S3 to RDS
resource "aws_glue_job" "glue_job_S3_to_RDS" {
   name     = "glue_job_S3_to_RDS"
   role_arn = aws_iam_role.iam_role_for_glue.arn
   glue_version =  "3.0"

   command {
     script_location = "s3://${aws_s3_bucket.script-bucket.bucket}/scripts/electricity-data-glue-job.py"
   }
 }