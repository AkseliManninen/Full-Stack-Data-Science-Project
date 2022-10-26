# Project plan

The goal of the project is to create end-to-end data pipeline and visualize the results.

The initial plan for the iteration is the following:

1. Find an interesting API that provides data at least on a weekly rate but preferable on daily or more often.

2. Move the data from the API to S3 bucket using AWS Lambda.

3. Use AWS Glue to modify data and to push to a database. The database could be MySql / DynamoDB.
3. Or use SageMaker to do ML on the data, and then push to a database.

4. Visualize the results, either in PowerBI, or construct a Flask website.

5. Use Terraform for Infrastructure-as-Code


# 1 APIs option 1: 7Timer, option 2: API-NBA, option 3: Twitter API

Searching for an API that would provide at least daily data. The API dictates a lot about the project, so finding a meaningful API is important. The data could be numbers where some kind of analysis, statistic or machine learning could be utilized. However, the data could also be in text format.

1.1 7Timer:
Weather API

1.2 API-NBA

1.3 Twitter API

NLP with tweets

