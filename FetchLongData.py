import boto3
import requests

# Get the token for the API
token = "djnK2W5vhk3W4fDZIZA9ka3Blr4ncJsv4R3mgFYK"

# Header for the api
headers = {'x-api-key': token}

# Randomly selected start and end times
start_time = "2020-01-01T00:00:00+00:00"
end_time = "2022-11-16T23:00:00+00:00"

query = {
        "start_time": start_time,
        "end_time": end_time,
        }

# URL for the API, where 124 is the variableId
url = "https://api.fingrid.fi/v1/variable/124/events/csv?" 

response = requests.get(url, headers=headers, params = query)

print(response.status_code)

bucket_name = "electricity-data-bucket"
file_name = "electricity_data.csv"
s3_path = file_name

string = response.text

s3 = boto3.resource("s3")
s3.Bucket(bucket_name).put_object(Key=s3_path, Body=string)

def lambda_handler(event, context):
    return {
        'statusCode': 200,
    }
