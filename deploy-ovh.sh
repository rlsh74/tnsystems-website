#!/bin/bash

# =============================================================================
# TN Systems Website Deployment Script for OVH VPS
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="tnsystems.ai"
APP_NAME="tnsystems-app"
USER="tnsystems"
APP_DIR="/var/www/${DOMAIN}"
NODE_VERSION="20"

# Functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root"
   exit 1
fi

log "Starting TN Systems deployment on OVH VPS..."

# =============================================================================
# System Updates
# =============================================================================
log "Updating system packages..."
apt update && apt upgrade -y

# =============================================================================
# Install Essential Tools
# =============================================================================
log "Installing essential tools..."
apt install -y curl wget git htop nano ufw certbot python3-certbot-nginx

# =============================================================================
# Create Application User
# =============================================================================
log "Creating application user: ${USER}"
if ! id "${USER}" &>/dev/null; then
    adduser --disabled-password --gecos "" ${USER}
    usermod -aG sudo ${USER}
    success "User ${USER} created successfully"
else
    warning "User ${USER} already exists"
fi

# =============================================================================
# Install Node.js
# =============================================================================
log "Installing Node.js ${NODE_VERSION}..."
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
apt install -y nodejs
success "Node.js $(node --version) installed successfully"

# =============================================================================
# Install PM2
# =============================================================================
log "Installing PM2..."
npm install -g pm2
success "PM2 installed successfully"

# =============================================================================
# Install and Configure Nginx
# =============================================================================
log "Installing Nginx..."
apt install -y nginx
systemctl start nginx
systemctl enable nginx
success "Nginx installed and started"

# =============================================================================
# Setup Firewall
# =============================================================================
log "Configuring firewall..."
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable
success "Firewall configured"

# =============================================================================
# Create Application Directory
# =============================================================================
log "Creating application directory..."
mkdir -p ${APP_DIR}
chown -R ${USER}:${USER} ${APP_DIR}
success "Application directory created: ${APP_DIR}"

# =============================================================================
# Create Nginx Configuration
# =============================================================================
log "Creating Nginx configuration..."
cat > /etc/nginx/sites-available/${DOMAIN} << EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${APP_DIR}/public;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Gzip compression
    gzip on;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    
    # Static files
    location / {
        try_files \$uri \$uri/ @nodejs;
    }
    
    # Proxy to Node.js
    location @nodejs {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # Static assets caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Logs
    access_log /var/log/nginx/${DOMAIN}.access.log;
    error_log /var/log/nginx/${DOMAIN}.error.log;
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test configuration
nginx -t
systemctl restart nginx
success "Nginx configuration created and activated"

# =============================================================================
# Create Environment File Template
# =============================================================================
log "Creating environment file template..."
su - ${USER} -c "cat > ${APP_DIR}/.env << EOF
NODE_ENV=production
PORT=3000
DOMAIN=${DOMAIN}
EMAIL_USER=tnsystems.ai@gmail.com
EMAIL_PASS=your_app_password_here
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
EOF"

chown ${USER}:${USER} ${APP_DIR}/.env
success "Environment file template created"

# =============================================================================
# Create PM2 Ecosystem File
# =============================================================================
log "Creating PM2 ecosystem file..."
su - ${USER} -c "cat > ${APP_DIR}/ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: '${APP_NAME}',
    script: 'server.js',
    cwd: '${APP_DIR}',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '${APP_DIR}/logs/err.log',
    out_file: '${APP_DIR}/logs/out.log',
    log_file: '${APP_DIR}/logs/combined.log',
    time: true
  }]
};
EOF"

# Create logs directory
mkdir -p ${APP_DIR}/logs
chown -R ${USER}:${USER} ${APP_DIR}/logs
success "PM2 ecosystem file created"

# =============================================================================
# Create Deployment Script
# =============================================================================
log "Creating deployment script..."
cat > ${APP_DIR}/deploy.sh << 'EOF'
#!/bin/bash

# TN Systems Deployment Script
APP_DIR="/var/www/tnsystems.ai"
APP_NAME="tnsystems-app"

cd $APP_DIR

# Install dependencies
echo "Installing dependencies..."
npm install --production

# Restart application
echo "Restarting application..."
pm2 restart $APP_NAME

# Check status
pm2 status

echo "Deployment completed!"
EOF

chmod +x ${APP_DIR}/deploy.sh
chown ${USER}:${USER} ${APP_DIR}/deploy.sh
success "Deployment script created"

# =============================================================================
# Create SSL Certificate Script
# =============================================================================
log "Creating SSL certificate script..."
cat > /usr/local/bin/setup-ssl.sh << EOF
#!/bin/bash

# Setup SSL certificate for ${DOMAIN}
echo "Setting up SSL certificate for ${DOMAIN}..."

# Get certificate
certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --non-interactive --agree-tos --email admin@${DOMAIN}

# Setup auto-renewal
if ! crontab -l 2>/dev/null | grep -q "certbot renew"; then
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
fi

echo "SSL certificate setup completed!"
EOF

chmod +x /usr/local/bin/setup-ssl.sh
success "SSL setup script created"

# =============================================================================
# Create System Service (Alternative to PM2)
# =============================================================================
log "Creating systemd service file..."
cat > /etc/systemd/system/${APP_NAME}.service << EOF
[Unit]
Description=TN Systems Website
After=network.target

[Service]
Type=simple
User=${USER}
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
success "Systemd service created"

# =============================================================================
# Create Backup Script
# =============================================================================
log "Creating backup script..."
cat > /usr/local/bin/backup-website.sh << EOF
#!/bin/bash

# Website backup script
BACKUP_DIR="/var/backups/tnsystems"
DATE=\$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="tnsystems_backup_\$DATE.tar.gz"

# Create backup directory
mkdir -p \$BACKUP_DIR

# Create backup
tar -czf \$BACKUP_DIR/\$BACKUP_FILE -C ${APP_DIR} .

# Keep only 7 days of backups
find \$BACKUP_DIR -name "tnsystems_backup_*.tar.gz" -mtime +7 -delete

echo "Backup created: \$BACKUP_DIR/\$BACKUP_FILE"
EOF

chmod +x /usr/local/bin/backup-website.sh
success "Backup script created"

# =============================================================================
# Final Instructions
# =============================================================================
log "Setting up PM2 startup script..."
su - ${USER} -c "pm2 startup" | grep -o 'sudo.*' | bash

success "=== TN Systems VPS Setup Complete! ==="
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Copy your website files to: ${APP_DIR}"
echo "2. Edit environment variables in: ${APP_DIR}/.env"
echo "3. Start the application: su - ${USER} -c 'cd ${APP_DIR} && pm2 start ecosystem.config.js'"
echo "4. Setup SSL certificate: /usr/local/bin/setup-ssl.sh"
echo "5. Configure DNS A records for ${DOMAIN} pointing to this server's IP"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "- Check app status: su - ${USER} -c 'pm2 status'"
echo "- View logs: su - ${USER} -c 'pm2 logs ${APP_NAME}'"
echo "- Deploy updates: su - ${USER} -c '${APP_DIR}/deploy.sh'"
echo "- Create backup: /usr/local/bin/backup-website.sh"
echo ""
echo -e "${GREEN}Server Info:${NC}"
echo "- App Directory: ${APP_DIR}"
echo "- App User: ${USER}"
echo "- Node.js Version: $(node --version)"
echo "- PM2 Version: $(pm2 --version)"
echo "- Nginx Status: $(systemctl is-active nginx)"
echo ""
echo -e "${BLUE}🎉 Ready to deploy TN Systems website!${NC}" 