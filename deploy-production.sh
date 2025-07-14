#!/bin/bash
# Production Deployment Script for TN Systems
# Domain: domain.com
# Target: European VPS (OVH/Scaleway/Hetzner)

set -e

echo "🚀 Starting TN Systems deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="tnsystems.ai"
APP_NAME="tn-systems"
PORT=3000

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
echo -e "${YELLOW}🟢 Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
echo -e "${YELLOW}⚡ Installing PM2 process manager...${NC}"
sudo npm install -g pm2

# Install Nginx
echo -e "${YELLOW}🌐 Installing Nginx...${NC}"
sudo apt install -y nginx

# Install Certbot for SSL
echo -e "${YELLOW}🔒 Installing Certbot for SSL...${NC}"
sudo apt install -y certbot python3-certbot-nginx

# Setup firewall
echo -e "${YELLOW}🛡️ Configuring firewall...${NC}"
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Create app directory
echo -e "${YELLOW}📁 Creating application directory...${NC}"
sudo mkdir -p /var/www/$APP_NAME
sudo chown -R $USER:$USER /var/www/$APP_NAME

# Copy application files
echo -e "${YELLOW}📋 Copying application files...${NC}"
cp -r . /var/www/$APP_NAME/
cd /var/www/$APP_NAME

# Install dependencies
echo -e "${YELLOW}📦 Installing application dependencies...${NC}"
npm install --production

# Create environment file
echo -e "${YELLOW}⚙️ Creating environment configuration...${NC}"
cat > .env << EOL
NODE_ENV=production
PORT=$PORT
FRONTEND_URL=https://$DOMAIN
EMAIL_SERVICE=gmail
EMAIL_USER=tnsystems.ai@gmail.com
EMAIL_PASS=your-gmail-app-password
COMPANY_EMAIL=tnsystems.ai@gmail.com
EOL

echo -e "${RED}⚠️  IMPORTANT: Edit .env file with your actual email credentials!${NC}"

# Create Nginx configuration
echo -e "${YELLOW}🌐 Creating Nginx configuration...${NC}"
sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null << EOL
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;
    
    # SSL configuration will be added by Certbot
    
    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Enable site
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
echo -e "${YELLOW}🧪 Testing Nginx configuration...${NC}"
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Start application with PM2
echo -e "${YELLOW}🚀 Starting application with PM2...${NC}"
pm2 start server.js --name $APP_NAME
pm2 startup
pm2 save

# Setup SSL with Certbot
echo -e "${YELLOW}🔒 Setting up SSL certificate...${NC}"
echo -e "${RED}⚠️  Make sure DNS records are pointing to this server before continuing!${NC}"
read -p "Press Enter to continue with SSL setup, or Ctrl+C to cancel..."

sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email contact@$DOMAIN

# Setup auto-renewal
echo -e "${YELLOW}🔄 Setting up SSL auto-renewal...${NC}"
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

# Create startup script
echo -e "${YELLOW}📝 Creating startup script...${NC}"
cat > /var/www/$APP_NAME/start.sh << 'EOL'
#!/bin/bash
cd /var/www/tn-systems
pm2 start server.js --name tn-systems
EOL

chmod +x /var/www/$APP_NAME/start.sh

# Final status check
echo -e "${GREEN}✅ Deployment completed!${NC}"
echo -e "${GREEN}🌐 Your website should be available at: https://$DOMAIN${NC}"
echo -e "${GREEN}📊 PM2 status:${NC}"
pm2 status

echo -e "${YELLOW}📋 Next steps:${NC}"
echo -e "1. Edit /var/www/$APP_NAME/.env with your email credentials"
echo -e "2. Restart PM2: pm2 restart $APP_NAME"
echo -e "3. Check DNS records are pointing to this server"
echo -e "4. Test website functionality"
echo -e "5. Set up monitoring and backups"

echo -e "${GREEN}🎉 TN Systems website deployment completed successfully!${NC}" 