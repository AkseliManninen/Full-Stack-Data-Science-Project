# Project plan

The goal of the project is to create end-to-end data pipeline and visualize the results.

The initial plan for the iteration is the following:

1. Find an interesting API that provides data at least on a weekly rate but preferable on daily or more often.

1.1 API option 1: 7Timer, option 2: API-NBA, option 3: Twitter API

2. Move the data from the API to S3 bucket using AWS Lambda.

3. Use AWS Glue to modify data and to push to a database. The database could be MySql / DynamoDB.
3. Or use SageMaker to do ML on the data, and then push to a database.

4. Visualize the results, either in PowerBI, or construct a Flask website.

5. Use Terraform for Infrastructure-as-Code


