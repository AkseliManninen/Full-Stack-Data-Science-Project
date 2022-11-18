# Lambda function for daily data 
data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "FetchData.py" 
  output_path = "lambda_function.zip"
}

data "aws_iam_role" "iam_role_for_lambda" {
  name = "lambda-upload-s3-akseli"
}

resource "aws_lambda_function" "FetchData" {
  filename      = "lambda_function.zip"
  function_name = "fetch_data_lambda"
  role          = data.aws_iam_role.iam_role_for_lambda.arn
  #role          = aws_iam_role.iam_role_for_lambda.arn # This is how the role would have been assignned if it was created in the same file.
  handler       = "FetchData.lambda_handler" 
  layers        = ["arn:aws:lambda:eu-west-1:065739622999:layer:python_layer:1"]
  source_code_hash = filebase64sha256("lambda_function.zip") # Needed to have to include the changes in the python file to the lambda function.

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Cloudwatch event to trigger the lambda function
resource "aws_cloudwatch_event_rule" "daily_event" {
    name = "daily_event"
    description = "Fires every day at 01.00"
    # rate every day at 01.00 UTC
    schedule_expression = "cron(0 1 * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_day" {
    rule = aws_cloudwatch_event_rule.daily_event.name
    target_id = "check_foo"
    arn = aws_lambda_function.FetchData.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.FetchData.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.daily_event.arn
}


# Lambda function for long data
data "archive_file" "python_lambda_package2" {  
  type = "zip"  
  source_file = "FetchLongData.py" 
  output_path = "fetch_long_data.zip"
}

data "aws_iam_role" "iam_role_for_lambda2" {
  name = "lambda-upload-s3-akseli"
}

resource "aws_lambda_function" "FetchLongData" {
  filename      = "fetch_long_data.zip"
  function_name = "fetch_long_data_lambda"
  role          = data.aws_iam_role.iam_role_for_lambda2.arn
  #role          = aws_iam_role.iam_role_for_lambda.arn # This is how the role would have been assignned if it was created in the same file.
  handler       = "FetchLongData.lambda_handler" 
  layers        = ["arn:aws:lambda:eu-west-1:065739622999:layer:python_layer:1"]
  source_code_hash = filebase64sha256("fetch_long_data.zip") # Needed to have to include the changes in the python file to the lambda function.

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Implementation ends here

# ---------------------------------------------------------------------------------------------------------------------------


# terraform init > terraform plan > terraform apply

# Example role for lambda function

#resource "aws_iam_role" "iam_role_for_lambda" {
#  name = "iam_role_for_lambda"

#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}
