#!/bin/bash
yum install -y httpd awscli

mkdir -p /var/www/html/images


# Retry S3 copy because IAM/VPC may not be ready immediately
for i in {1..10}; do
    aws s3 cp s3://${images_bucket}/ourimage.jpg /var/www/html/images/ourimage.jpg && break
    echo "Retry attempt $i failed, retrying..."
    sleep 5
done

echo "<h1>${env_upper} SERVER</h1><img src='/images/ourimage.jpg'>" > /var/www/html/index.html

systemctl enable httpd
systemctl start httpd
