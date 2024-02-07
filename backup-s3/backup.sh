#!/bin/bash

# Define PostgreSQL connection parameters
PG_HOST=$POSTGRES_HOST
PG_PORT=$POSTGRES_PORT
PG_DB=$POSTGRES_DB
PG_USER=$POSTGRES_USER
PG_PASSWORD=$postgres_password

# Define AWS S3 bucket details
AWS_BUCKET=$BUCKET_NAME
AWS_REGION=$AWS_DEFAULT_REGION
aws_access_key_id=$aws_access_key_id
aws_secret_access_key=$aws_secret_access_key

# Configure AWS credentials
aws configure set aws_access_key_id "$aws_access_key_id" && \
aws configure set aws_secret_access_key "$aws_secret_access_key" && \
aws configure set default.region "$AWS_REGION" && \
aws configure set output json

# Create backup filename with timestamp
BACKUP_DIR=/backupa1
BACKUP_FILE="$BACKUP_DIR/babette_$(date +'%Y%m%d_%H%M%S').sql"

# Perform the backup using pg_dump
PGPASSWORD=$PG_PASSWORD pg_dump -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful. Backup file: $BACKUP_FILE"
else
    echo "Backup failed."
    exit 1
fi

# Upload backup file to AWS S3 bucket
aws s3 cp "$BACKUP_FILE" "s3://$AWS_BUCKET"

# Check if upload was successful
if [ $? -eq 0 ]; then
    echo "Backup file uploaded to S3 bucket: $AWS_BUCKET"
    # Optionally, you can delete the local backup file after upload
    # rm "$BACKUP_FILE"
else
    echo "Upload to S3 failed."
    exit 1
fi
