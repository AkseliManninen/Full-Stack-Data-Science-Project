# This files is used for creating RDS database, a Glue crawler and connection for MySQL and permissions

# Creates a MySQL RDS database
resource "aws_db_instance" "electricity-data-database" {
  allocated_storage    = 20 # Minimum storage
  db_name              = "electricity_data_database" 
  identifier = "electricity-data-database"
  engine               = "mysql" 
  engine_version       = "8.0.28" # Default version at the time
  instance_class       = "db.t3.micro" # Cheapest version
  username             = var.mysql_username
  password             = var.mysql_password
  skip_final_snapshot  = true
  publicly_accessible = true
}

# parameter_group_name: default.mysql8.0.28
# Storage type: General Purpose SSD (gp2)
# Storage autoscaling: Disabled
resource "aws_glue_catalog_database" "my_database" {
  name = "mysql_database"
}

# Creates a Glue connection to MySQL
resource "aws_glue_connection" "glue_connection" {
  connection_properties = {
    JDBC_CONNECTION_URL = var.connection_url
    USERNAME            = var.mysql_username
    PASSWORD            = var.mysql_password
    
  }
  name = "electricity-data-glue-connection"

  physical_connection_requirements {
    availability_zone      = "eu-west-1c"
    security_group_id_list = [var.security_group_id_list]
    subnet_id              = var.subnet_id
  }
}

# Creates a Glue crawler for MySQL
resource "aws_glue_crawler" "my_sql_crawler" {
  database_name = aws_glue_catalog_database.my_database.name
  name          = "my_sql_crawler"
  role          = aws_iam_role.iam_role_for_glue.arn 
  jdbc_target {
    connection_name = aws_glue_connection.glue_connection.name
    path             = "electricity_data_database"
  }
}

# Creating variables
variable "subnet_id" {
  type        = string
  description = "subnet id variable"
}

variable "mysql_username" {
  type        = string
  description = "username for MySql"
}

variable "mysql_password" {
  type        = string
  description = "Password for MySql"
}

variable "connection_url" {
  type        = string
  description = "Database connection url"
}

variable "security_group_id_list" {
  type        = string
  description = "Security group id"
}



