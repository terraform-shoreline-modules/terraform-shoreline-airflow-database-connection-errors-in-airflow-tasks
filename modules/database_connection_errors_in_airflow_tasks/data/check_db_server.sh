

#!/bin/bash



# Check if the database server is up and running

if ! systemctl status ${DATABASE_SERVICE_NAME} | grep -q "active (running)"; then

    # Bring the database server back online

    systemctl start ${DATABASE_SERVICE_NAME}

    echo "Database server has been restarted."

fi