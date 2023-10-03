terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "database_connection_errors_in_airflow_tasks" {
  source    = "./modules/database_connection_errors_in_airflow_tasks"

  providers = {
    shoreline = shoreline
  }
}