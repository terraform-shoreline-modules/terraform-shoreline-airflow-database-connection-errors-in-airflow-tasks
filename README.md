
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Database connection errors in Airflow tasks.
---

This incident type refers to situations where Airflow tasks are unable to connect to the database due to errors. These errors may result from a variety of causes such as network issues, database configuration issues, or system overload. When such errors occur, the affected tasks may fail to complete successfully, leading to disruptions in the workflow.

### Parameters
```shell
export DATABASE_SERVICE_NAME="PLACEHOLDER"

export AIRFLOW_CONFIG_FILE="PLACEHOLDER"

export DATABASE_PORT="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"

export DATABASE_USER="PLACEHOLDER"

export AIRFLOW_TASK_FILE="PLACEHOLDER"
```

## Debug

### Check if the database is running
```shell
systemctl status ${DATABASE_SERVICE_NAME}
```

### Check if the database credentials are correct
```shell
cat ${AIRFLOW_CONFIG_FILE} | grep -E "sql_alchemy_conn"
```

### Check if the database is accepting connections
```shell
nc -zv ${DATABASE_HOST} ${DATABASE_PORT}
```

### Check if the database user has sufficient privileges
```shell
psql -h ${DATABASE_HOST} -p ${DATABASE_PORT} -U ${DATABASE_USER} -c "SELECT 1"
```

### Check if the Airflow task is using the correct database connection
```shell
cat ${AIRFLOW_TASK_FILE} | grep -E "sql_alchemy_conn"
```

### Concurrent database connections limit exceeded.
```shell
bash

#!/bin/bash



# Get the maximum number of concurrent database connections allowed

max_connections=$(sudo su - postgres -c "psql -t -c 'SHOW max_connections;'" | tr -d '[:space:]')

echo "Maximum number of concurrent database connections allowed: $max_connections"



# Get the current number of connections to the database

current_connections=$(sudo su - postgres -c "psql -t -c 'SELECT count(*) FROM pg_stat_activity;'" | tr -d '[:space:]')

echo "Current number of connections to the database: $current_connections"



# Calculate the percentage of connections in use

percent_in_use=$(awk "BEGIN {printf \"%.1f\", ($current_connections / $max_connections) * 100}")

echo "Percentage of connections in use: $percent_in_use%"



# Check if the percentage of connections in use exceeds a certain threshold (e.g. 80%)

threshold=80

if (( $(echo "$percent_in_use >= $threshold" | bc -l) )); then

    echo "Concurrent database connections limit exceeded."

else

    echo "Concurrent database connections limit not exceeded."

fi


```

## Repair

### Check if the database server is up and running. If the server is down, bring it back online as soon as possible.
```shell


#!/bin/bash



# Check if the database server is up and running

if ! systemctl status ${DATABASE_SERVICE_NAME} | grep -q "active (running)"; then

    # Bring the database server back online

    systemctl start ${DATABASE_SERVICE_NAME}

    echo "Database server has been restarted."

fi


```