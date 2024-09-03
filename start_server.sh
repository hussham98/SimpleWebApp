#!/bin/bash

# Install Python if it's not already installed
sudo yum install python3 -y

# Copy the web app files to the correct location (if needed)
sudo cp index.html /var/www/html/

# Navigate to the directory where the HTML file is located
cd /var/www/html

# Start a simple Python HTTP server
python3 -m http.server 80
