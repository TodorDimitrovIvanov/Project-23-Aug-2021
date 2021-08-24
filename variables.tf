# Here we define the variable names that are to be used in the deployment
# Note that we also define the variable type and provide a short description for it
# However the values that these variables will hold are to be assigned via the 'terraform.tfvars' file 
variable "resource_group_name" {
    type        = string
    description = "The Resource Group name of the Azure deployment"
}

variable "resource_group_location" {
    type = string
    description = "The location of the Azure Resource Group"
}

variable "webapp_service_plan_name" {
    type = string
    description = "The name of the Subscription plan that's going to be used for the deployment"
}

variable "webapp_service_name" {
    type = string
    description = "The name of the service that's going to manage the Webapp"
}

variable "sql_server_name" {
    type = string
    description = "The name of the MariaDB server that will be setup through Azure"
}

variable "sql_database_name" {
    type = string
    description = "The name of the MariaDB database that's going to be used"
}

variable "sql_admin_login" {
    type = string
    description = "The username that will connect to the MariaDB database"
}

variable "sql_admin_password" {
    type = string
    description = "The password of the username that will connect to the database"
}