# Project description

The electricity data project was established in the mids of an European energy crisis. The motivation for the project is to to distribute electricity related infromation in a structed and insightful way. The data is collected from public sources.

## Project implementation

Data is collected from two APIs: 
1. Fingrid API - The API provides data about Finnish electricity production and consumption.
2. Nordpool API - The API provides the prices for electricity in the Nordisc.

The data is collected from the APIs to Amazon Web Services' S3 data strorage using AWS Lambda functions. A Lambda function is triggered daily by Cloudwatch. Then the data is moved from S3 with an ETL tool AWS Glue to a MySQL relational database. From there a connection is established with Google's Looker Studio, and the data is visualised. The aim is that the analytics are then embedded on a website.

In the project, Github is used for version control and Terraform is used for Infrastructure-as-Code.

## Architecture

The graph below describes the implemented architecture rougly. There will be some additional components like for example AWS CloudWatch triggering Glue, which is not included yet in the desing.

![image](https://user-images.githubusercontent.com/75692903/202676304-f727613e-2ad1-4a6b-aee0-0b1c3fd7522d.png)

## 3. Terraform
The next step is to define AWS resources using Terraform. 

- S3 - Store data fetched from the API 🟢
- Lambda 🟡
-   Lambda function 1 - Fetches 1 year of data and adds it to S3  🟢
-   Lambda function 2 - Fetches the data from previous day and adds it to the existing csv 🟢
-   Include NordPool and more data points from Fingrid 🟡
- Cloud Watch 🟡
  - Event rule - Triggers the Lambda function 2 daily 🟢
  - Event rule - Triggers Glue crawlers daily 🟡
- Glue 
  - Glue databases for S3 and RDS 🟢
  - Glue crawler for S3 🟢
  - Glue crawler for RDS 🟢
  - Glue job 🟢
- RDS 🟢

## Requirements:
- Terraform
- AWS CLI
- requests library

## Other 
Configuring AWS with CLI (aws configure command): https://www.youtube.com/watch?v=XxTcw7UTues

## Report sneak peek

<iframe width="600" height="450" src="https://datastudio.google.com/embed/reporting/504f2c95-452d-438b-9a23-57faa79c0a3c/page/T2cBD" frameborder="0" style="border:0" allowfullscreen></iframe>

## Installing request with AWS Lambda layer
- create a folder called python > pip3 install requests -t . --no-user > zip folder > add as a lambda layer (apparently the folder and zip needs to be named python to work): https://www.youtube.com/watch?v=3BH79Uciw5w&t=70s
