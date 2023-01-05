# Python script used in a Lambda function to fetch once data from API

import boto3
import requests
import numpy as np
import pandas as pd
from pandas.io.common import StringIO

# Get the token for the API
token = ## Add token here

# Headers for the api
headers = {'x-api-key': token}

# Selected start and end times
#start_time = "2020-01-01T00:00:00+00:00"
start_time = "2023-01-02T00:00:00+00:00"
end_time = "2023-01-04T23:00:00+00:00"

query = {
        "start_time": start_time,
        "end_time": end_time,
        }

# Variables
variables = ["74", "124", "165", "166", "241", "242"]
dataframes = []

for variable in variables:
    url = f"https://api.fingrid.fi/v1/variable/{variable}/events/csv?"

    response = requests.get(url, headers=headers, params = query)

    # Creates a file-like object from the string
    file = StringIO(response.text)

    # Read the CVS data from the file-like object int a Pandas dataframe
    df = pd.read_csv(file)
    
    df.rename(columns = {'value': variable}, inplace= True)

    dataframes.append(df)

data = dataframes[0]
dataframes = dataframes[1:]

# Combines the dataframes based on start and end times
for dataframe in dataframes:
        data = pd.merge(data, dataframe, on = ["start_time", "end_time"], how = "outer")

# Modifies the Pandas dataframe into a csv file
data = data.to_csv(index = False, header = True)

print(response.status_code)

bucket_name = "electricity-data-bucket"
file_name = "electricity_data_23.csv"
s3_path = file_name

s3 = boto3.resource("s3")
s3.Bucket(bucket_name).put_object(Key=s3_path, Body=data)

def lambda_handler(event, context):
    return {
        'statusCode': 200,
    }
