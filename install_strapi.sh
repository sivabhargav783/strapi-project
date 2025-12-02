#!/bin/bash

# 1. Update System
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Setup Swap Memory (Safety net for all instance types)
# We add 2GB Swap.
# On m7i-flex (8GB), this gives 10GB total.
# On t3.small (2GB), this gives 4GB total.
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 3. Install Node.js 20 (Required for Strapi v5)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential git

# 4. Install PM2
sudo npm install -g pm2

# 5. Clone the Repository
sudo rm -rf /srv/strapi-app
sudo git clone https://github.com/sivabhargav783/strapi-project.git /srv/strapi-app

# 6. Setup Permissions
sudo chown -R ubuntu:ubuntu /srv/strapi-app

# 7. Install & Build
cd /srv/strapi-app

# Install dependencies
sudo -u ubuntu npm install

# Build Strapi
# We set limit to 3GB. 
# This works great on m7i-flex (8GB) and fits into t3.small (2GB Phys + 2GB Swap).
export NODE_OPTIONS="--max-old-space-size=3072"
sudo -u ubuntu NODE_OPTIONS="--max-old-space-size=3072" npm run build

# 8. Start Application
sudo -u ubuntu pm2 start npm --name "strapi" -- run start

# 9. Startup Script
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo -u ubuntu pm2 save