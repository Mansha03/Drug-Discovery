#!/bin/bash

# Start MySQL service
echo "Starting MySQL service..."
service mysql start

# Check if MySQL service started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start MySQL service!"
    exit 1
fi

# Wait for MySQL to be ready
echo "Waiting for MySQL to start..."
while ! mysqladmin ping --silent; do
    sleep 1
done

echo "MySQL started successfully."

# Run MySQL commands
mysql --user=root --password=root<<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; 
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_&';
CREATE USER 'mlflow_user'@'localhost' IDENTIFIED BY 'mlflow';
GRANT ALL ON db_mlflow.* TO 'mlflow_user'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS db_mlflow;
SHOW DATABASES;
EOF

echo "All queries runned successfully."

# Tail MySQL error log
tail -f /var/log/mysql/error.log