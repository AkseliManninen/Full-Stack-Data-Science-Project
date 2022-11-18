import boto3
import requests
from datetime import date
from datetime import timedelta

yesterday = date.today() - timedelta(days=1)
yesterday_str = yesterday.strftime("%Y-%m-%d")

# Get the token for the API
token = "djnK2W5vhk3W4fDZIZA9ka3Blr4ncJsv4R3mgFYK"

# Header for the api
headers = {'x-api-key': token}

start_time = yesterday_str + "T00:00:00+00:00"
end_time = yesterday_str + "T23:00:00+00:00"


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

# get existing data from s3
current_data = boto3.client('s3').get_object(Bucket = bucket_name, Key = s3_path)['Body'].read().decode('utf-8')
    
string = string.splitlines(True)[1:]
string = ''.join(string)

append_data = str(current_data) + string
    
s3.Bucket(bucket_name).put_object(Key=s3_path, Body=append_data)


def lambda_handler(event, context):

    return {
        'statusCode': 200,
    }



#----------------------------------------------

# Randomly selected start and end times are in format:
#start_time = "2022-10-25T00:00:00+03:00"
#end_time = "2022-10-26T00:00:00+03:00"


    