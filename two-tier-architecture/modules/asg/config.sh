#!/bin/bash
# Update system packages
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a simple HTML page (optional)
echo "<h1>Welcome to My Auto Scaling Website</h1>" > /var/www/html/index.html

# OR copy your static website files from S3 (recommended for production)
# aws s3 cp s3://your-bucket-name/static-site/ /var/www/html/ --recursive

# Adjust permissions
sudo chmod -R 755 /var/www/html
