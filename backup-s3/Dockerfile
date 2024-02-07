# Use the official PostgreSQL image
FROM postgres:latest

# Install AWS CLI dependencies
RUN apt-get update \
    && apt-get install -y \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

WORKDIR /backupa1
COPY . .
RUN chmod +x backup.sh
CMD ["./backup.sh"]
