# IAM role for glue

resource "aws_iam_role" "iam_role_for_glue" {
  name = "iam_role_s3_glue"

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

# Glue database
resource "aws_glue_catalog_database" "s3_glue_database" {
  name = "s3_glue_database"
}

# Glue crawler S3 to Glue
resource "aws_glue_crawler" "s3_crawler" {
  database_name = aws_glue_catalog_database.s3_glue_database.name
  name          = "s3_crawler"
  role          = aws_iam_role.iam_role_for_glue.arn

  s3_target {
    path = "s3://${aws_s3_bucket.electricity-data-bucket.bucket}"
  }
}

#resource "aws_glue_job" "s3_to_rds" {
#  name     = "s3_to_rds"
#  role_arn = aws_iam_role.example.arn

#  command {
#    script_location = "s3://${aws_s3_bucket.example.bucket}/example.py"
#  }
#}

