# Corporate Deployment Guide for TN Systems

## European Hosting Options for Corporate Deployment

### 1. OVH (France) - RECOMMENDED
**Perfect for French companies**

#### Account Setup:
1. Go to https://www.ovh.com/fr/
2. Click "Créer un compte" → "Entreprise"
3. Fill company details:
   - Company: TN Systems
   - Country: France
   - VAT Number: FR[Company VAT]
   - Business registration

#### Hosting Options:
- **VPS Starter**: €3.50/month (1 vCore, 2GB RAM, 20GB SSD)
- **VPS Essential**: €7.00/month (1 vCore, 4GB RAM, 40GB SSD) - **RECOMMENDED**
- **VPS Comfort**: €14.00/month (2 vCores, 8GB RAM, 80GB SSD)

#### Deployment Steps:
```bash
# 1. Connect to VPS
ssh ubuntu@your-vps-ip

# 2. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Install PM2 (Process Manager)
sudo npm install -g pm2

# 4. Install Nginx (for domain routing)
sudo apt update
sudo apt install nginx

# 5. Upload and deploy
scp -r . ubuntu@your-vps-ip:/home/ubuntu/tn-systems/
cd /home/ubuntu/tn-systems/
npm install --production
pm2 start server.js --name "tn-systems"
pm2 startup
pm2 save
```

### 2. Scaleway (France)
**Modern European cloud provider**

#### Account Setup:
1. Go to https://www.scaleway.com/en/
2. Select "Business" account
3. Provide company details

#### Container Deployment:
```bash
# Build Docker image
docker build -t tn-systems .

# Deploy to Scaleway Container Registry
docker tag tn-systems registry.scaleway.com/tn-systems:latest
docker push registry.scaleway.com/tn-systems:latest
```

### 3. Hetzner (Germany)
**Reliable European hosting**

#### Account Setup:
1. Go to https://www.hetzner.com/
2. Create business account
3. Provide company registration details

#### VPS Options:
- **CX11**: €3.29/month (1 vCPU, 4GB RAM, 20GB SSD)
- **CX21**: €5.83/month (2 vCPU, 8GB RAM, 40GB SSD)

## Domain Configuration (tnsystems.ai)

### DNS Setup for your existing domain:
1. **Log into your tnsystems.ai account**
2. **Go to DNS Management**
3. **Add/Update DNS records:**

```
Type: A
Name: @ (or leave blank for root domain)
Value: YOUR_VPS_IP_ADDRESS
TTL: 300

Type: A  
Name: www
Value: YOUR_VPS_IP_ADDRESS
TTL: 300

Type: CNAME
Name: www
Value: tnsystems.ai
TTL: 300
```

### SSL Certificate Setup:
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d domain.com -d www.domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Nginx Configuration:
```nginx
# /etc/nginx/sites-available/tnsystems.ai
server {
    listen 80;
    server_name tnsystems.ai www.tnsystems.ai;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name tnsystems.ai www.tnsystems.ai;
    
    ssl_certificate /etc/letsencrypt/live/tnsystems.ai/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tnsystems.ai/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Pre-Deployment Checklist

### 1. Email Configuration
Set up corporate email for contact form:
```env
NODE_ENV=production
PORT=3000
FRONTEND_URL=https://tnsystems.ai
EMAIL_SERVICE=gmail
EMAIL_USER=tnsystems.ai@gmail.com
EMAIL_PASS=your-app-password
COMPANY_EMAIL=tnsystems.ai@gmail.com
```

### 2. Update HTML for Production
Update `index.html` domain references:
```html
<!-- Change from -->
<meta property="og:url" content="https://domain.com">
<!-- To your actual domain -->
<meta property="og:url" content="https://domain.com">
```

### 3. Security Setup
- Configure firewall (UFW)
- Set up SSL certificates (Let's Encrypt)
- Configure rate limiting
- Regular security updates

### 4. Monitoring Setup
- Set up server monitoring
- Configure email alerts
- Log monitoring
- Performance tracking

## Recommended: OVH VPS Essential

### Why OVH for TN Systems:
- ✅ French company → French hosting
- ✅ GDPR compliance by default
- ✅ Corporate billing with VAT
- ✅ 24/7 French support
- ✅ Data centers in France
- ✅ Excellent price/performance

### Monthly Cost Estimate:
- **VPS Essential**: €7.00/month
- **Domain**: Already owned ✅
- **SSL Certificate**: Free (Let's Encrypt)
- **Total**: €7.00/month

### Production Deployment Script:
```bash
#!/bin/bash
# deploy-production.sh

# Set environment variables
export NODE_ENV=production
export PORT=3000
export FRONTEND_URL=https://domain.com

# Start application
npm install --production
pm2 start server.js --name "tn-systems"
pm2 startup
pm2 save

# Configure Nginx
sudo ln -s /etc/nginx/sites-available/tnsystems.ai /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Get SSL certificate
sudo certbot --nginx -d tnsystems.ai -d www.tnsystems.ai

echo "✅ TN Systems website deployed successfully!"
echo "🌐 Visit: https://tnsystems.ai"
```

## Next Steps:
1. **Create OVH business account**
2. **Order VPS Essential**
3. **Configure tnsystems.ai DNS** (point to VPS IP)
4. **Deploy application using script above**
5. **Set up monitoring**
6. **Test all functionality**

## Quick Start Commands:
```bash
# After VPS setup and tnsystems.ai DNS configuration
git clone your-repo
cd tn-systems-website
chmod +x deploy-production.sh
./deploy-production.sh
```

**Contact**: For deployment assistance, contact your technical team or external developer. 