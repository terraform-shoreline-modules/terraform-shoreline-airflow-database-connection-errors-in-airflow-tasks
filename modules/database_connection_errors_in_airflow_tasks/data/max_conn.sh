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