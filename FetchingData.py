# This file is used for testing fetching data from the API for now
# We will uses this code in AWS Lambda to fetch data from the API

# Importing libraries
import requests
import urllib

# Get the token for the API
with open('token.txt') as file:
    token = file.read()


# Randomly selected start and end times
start_time = "2022-10-25T00:00:00+03:00"
end_time = "2022-10-26T00:00:00+03:00"

# Header for the api
headers = {'x-api-key': token}

query = {
        "start_time": start_time,
        "end_time": end_time,
        }
#encoded = urllib.parse.urlencode(query)

# URL for the API, where 124 is the variableId
url = "https://api.fingrid.fi/v1/variable/124/events/csv?" 

response = requests.get(url, headers=headers, params = query)

print(response.status_code)
print(response.text)