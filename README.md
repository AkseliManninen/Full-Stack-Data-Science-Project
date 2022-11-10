# Project plan

## Project goal

The goal of the project is to create end-to-end data pipeline and visualize the results.

## Project phases

The initial plan for the iteration is the following:

1. Find an interesting API that provides data at least on a weekly rate but preferable on daily or more often.

2. Draw the architecture for the project.

3. Establish the resources on AWS using Terraform (Infrastructure-as-Code)

4. Write a AWS Lambda function in Python that fetches the data from the API and stores the data in S3 bucket.

5. Use AWS Glue to modify data and to push to a database. The database could be MySql / DynamoDB.
5. Or use SageMaker to do ML on the data, and then push to a database.

6. Visualize the results, either in PowerBI, or construct a Flask website.

7. Add tests

8. Document the project in a READ.me file.

## 1. APIs

The first phase is to search and select an interesting API which provides the data. The API should provide new data often, preferably at least daily. Data is in the core of this project, so finding an awesome API is important.

The format of the data should be primarily numbers and strings. In order to do some kind of statistical analysis or machine learning, the number format would be the easiest. However, other types of data are not totally excluded from consideration.

1.1 7Timer

7Timer provides data about weather. For example predicting weather in Otaniemi (not sure if this API provides data for that area).

1.2 API-NBA

NBA API provides data about NBA games. For example, predicting if a team wins could be fun. The data might not be frequent enough for this project.

1.3 Twitter API

Twitter API provides tweets. Tweets could be utilized for example in NLP.

1.4 Fingrid API

This API provides data about Finnish electricity production and consumption.

1.5 Nordpool API

This Api provides the prices for electricity in the Nordics.

Selected API was Fingrid, as it provided interesting data and did not require excessive work to aqcuire the authentication token. For later, it could be considered to for example scrape some data from Nordpool.

## 2. Architecture

This is the planned architecture roughly. There still might be some changes regarding for example glue and sagemaker but otherwise it should describe the final architecture accurately.

![image](https://user-images.githubusercontent.com/75692903/198521668-4c653f48-6ca4-496b-b622-cbc48ef4e733.png)

AWS Lambda makes API calls to fetch data and then stores the data in a S3 bucket. Lambda is triggered by Cloudwatch (add to the architecture) daily. From the S3 bucket Glue reads the data, modifies it and stores to a database. From a database data can be accessed with PowerBI which has built-in integration.

Also, the API token needs to be stored in KMS. (Add later to the architecture)

## 3. Terraform
The next step is to define AWS resources using Terraform. 

- S3 - Ok
- Lambda - Ok
- Cloud Watch
- Glue
- RDS
- 

## Requirements:
- Terraform
- AWS CLI
- requests library

## Other 
Configuring AWS with CLI (aws configure command):https://www.youtube.com/watch?v=XxTcw7UTues

## Installing request with AWS Lambda layer
- create a folder called python > pip3 install requests -t . --no-user > zip folder > add as a lambda layer (apparently the folder and zip needs to be named python to work): https://www.youtube.com/watch?v=3BH79Uciw5w&t=70s
