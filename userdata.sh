#!/bin/bash

# Update the package list
sudo apt-get update

# Install Apache
sudo apt-get install -y apache2

# Create the HTML content
sudo bash -c "cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html><body><h1>Welcome to Terraform Hands on with AWS VPC</h1></body></html>
HTML"

# Restart Apache
sudo systemctl restart apache2
