# This file is used for creating Lambda functions, Cloudwatch triggers and permissions

# Uses an existing iam role
data "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"
}

# Creates an archive file used with a Lambda function that fetches daily data
data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "FetchData.py" 
  output_path = "lambda_function.zip"
}

# Creates a Lambda function for fetching data daily from an API
resource "aws_lambda_function" "FetchData" {
  filename      = "lambda_function.zip"
  function_name = "fetch_data_lambda"
  role          = data.aws_iam_role.iam_role_for_lambda.arn
  handler       = "FetchData.lambda_handler" 
  layers        = ["arn:aws:lambda:eu-west-1:065739622999:layer:python_layer:1", "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python38:2"]
  source_code_hash = filebase64sha256("lambda_function.zip") # Needed to have to include the changes in the python file to the lambda function.

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Creates a Cloudwatch event rule that triggers daily
resource "aws_cloudwatch_event_rule" "daily_event" {
    name = "daily_event"
    description = "Fires every day at 01.00"
    # rate every day at 01.00 UTC
    schedule_expression = "cron(0 1 * * ? *)"
}

# Creates a Cloudwatch event target that runs the Lambda function
resource "aws_cloudwatch_event_target" "check_foo_every_day" {
    rule = aws_cloudwatch_event_rule.daily_event.name
    target_id = "check_foo"
    arn = aws_lambda_function.FetchData.arn
}

# Creates a Lambda permission for Cloudwatch
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

# Creates a Lambda function that fetches data from API (once)
resource "aws_lambda_function" "FetchLongData" {
  filename      = "fetch_long_data.zip"
  function_name = "fetch_long_data_lambda"
  role          = data.aws_iam_role.iam_role_for_lambda.arn
  handler       = "FetchLongData.lambda_handler" 
  layers        = ["arn:aws:lambda:eu-west-1:065739622999:layer:python_layer:1", "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python38:2"]
  source_code_hash = filebase64sha256("fetch_long_data.zip") # Needed to have to include the changes in the python file to the lambda function.

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}