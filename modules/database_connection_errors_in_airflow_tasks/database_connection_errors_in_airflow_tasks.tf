resource "shoreline_notebook" "database_connection_errors_in_airflow_tasks" {
  name       = "database_connection_errors_in_airflow_tasks"
  data       = file("${path.module}/data/database_connection_errors_in_airflow_tasks.json")
  depends_on = [shoreline_action.invoke_max_conn,shoreline_action.invoke_check_db_server]
}

resource "shoreline_file" "max_conn" {
  name             = "max_conn"
  input_file       = "${path.module}/data/max_conn.sh"
  md5              = filemd5("${path.module}/data/max_conn.sh")
  description      = "Concurrent database connections limit exceeded."
  destination_path = "/agent/scripts/max_conn.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_db_server" {
  name             = "check_db_server"
  input_file       = "${path.module}/data/check_db_server.sh"
  md5              = filemd5("${path.module}/data/check_db_server.sh")
  description      = "Check if the database server is up and running. If the server is down, bring it back online as soon as possible."
  destination_path = "/agent/scripts/check_db_server.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_max_conn" {
  name        = "invoke_max_conn"
  description = "Concurrent database connections limit exceeded."
  command     = "`chmod +x /agent/scripts/max_conn.sh && /agent/scripts/max_conn.sh`"
  params      = []
  file_deps   = ["max_conn"]
  enabled     = true
  depends_on  = [shoreline_file.max_conn]
}

resource "shoreline_action" "invoke_check_db_server" {
  name        = "invoke_check_db_server"
  description = "Check if the database server is up and running. If the server is down, bring it back online as soon as possible."
  command     = "`chmod +x /agent/scripts/check_db_server.sh && /agent/scripts/check_db_server.sh`"
  params      = ["DATABASE_SERVICE_NAME"]
  file_deps   = ["check_db_server"]
  enabled     = true
  depends_on  = [shoreline_file.check_db_server]
}

