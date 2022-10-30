# Lambda function
data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "fetch_data.py" 
  output_path = "lambda_function.zip"
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "fetch_data" {
  filename      = "lambda_function.zip"
  function_name = "fetch_data_lambda"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "fetch_data.lambda_handler" 

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


# terraform init > terraform plan > terraform apply
