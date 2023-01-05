# Python script used in a Lambda function to fetch daily data from API

import boto3
import requests
from datetime import date
from datetime import timedelta
import pandas as pd
from pandas.io.common import StringIO
import numpy as np

yesterday = date.today() - timedelta(days=1)
yesterday_str = yesterday.strftime("%Y-%m-%d")

today_str = date.today().strftime("%Y-%m-%d")

# Get the token for the API
token = ## Add token here

# Header for the api
headers = {'x-api-key': token}

start_time = yesterday_str + "T00:00:00+00:00"
end_time = today_str + "T23:00:00+00:00"


query = {
        "start_time": start_time,
        "end_time": end_time,
        }

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

# header = False pystyy säätäää, ettei tuu otsikot mukaa
data = data.to_csv(index = False, header = False)

bucket_name = "electricity-data-bucket"
file_name = "electricity_data_23.csv"
s3_path = file_name

s3 = boto3.resource("s3")

# get existing data from s3
current_data = boto3.client('s3').get_object(Bucket = bucket_name, Key = s3_path)['Body'].read().decode('utf-8')

append_data = str(current_data) + str(data)
    
s3.Bucket(bucket_name).put_object(Key=s3_path, Body=append_data)


def lambda_handler(event, context):

    return {
        'statusCode': 200,
    }




#----------------------------------------------

# Randomly selected start and end times are in format:
#start_time = "2022-10-25T00:00:00+03:00"
#end_time = "2022-10-26T00:00:00+03:00"


    