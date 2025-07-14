# TN Systems Website - Deployment Guide

## 🚀 Quick Deployment Options

### Option 1: Vercel (Recommended for Fast Deploy)

1. **Install Vercel CLI:**
   ```bash
   npm i -g vercel
   ```

2. **Deploy:**
   ```bash
   vercel
   ```

3. **Set Environment Variables:**
   ```bash
   vercel env add EMAIL_SERVICE
   vercel env add EMAIL_USER
   vercel env add EMAIL_PASS
   vercel env add COMPANY_EMAIL
   ```

4. **Custom Domain:**
   ```bash
   vercel domains add domain.com
   ```

### Option 2: Docker Deployment

1. **Build Image:**
   ```bash
   docker build -t tn-systems-website .
   ```

2. **Run Container:**
   ```bash
   docker run -d \
     --name tn-website \
     -p 80:3000 \
     -e EMAIL_SERVICE=gmail \
     -e EMAIL_USER=your-email@gmail.com \
     -e EMAIL_PASS=your-app-password \
     -e COMPANY_EMAIL=contact@domain.com \
     tn-systems-website
   ```

### Option 3: Traditional VPS/Server

1. **Server Setup:**
   ```bash
   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Install PM2 for process management
   npm install -g pm2
   ```

2. **Deploy Application:**
   ```bash
   # Clone repository
   git clone https://github.com/tn-systems/website.git
   cd website
   
   # Install dependencies
   npm install --production
   
   # Set environment variables
   cp env.example .env
   # Edit .env with your values
   
   # Start with PM2
   pm2 start server.js --name "tn-website"
   pm2 startup
   pm2 save
   ```

3. **Nginx Configuration:**
   ```nginx
   server {
       listen 80;
       server_name domain.com www.domain.com;
       
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

4. **SSL Certificate:**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d domain.com -d www.domain.com
   ```

### Option 4: DigitalOcean App Platform

1. **Create App:**
   - Connect GitHub repository
   - Set build command: `npm install`
   - Set run command: `npm start`

2. **Environment Variables:**
   ```
   NODE_ENV=production
   EMAIL_SERVICE=gmail
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   COMPANY_EMAIL=contact@domain.com
   ```

### Option 5: AWS Deployment

#### Option 5a: AWS Elastic Beanstalk

1. **Install EB CLI:**
   ```bash
   pip install awsebcli
   ```

2. **Initialize and Deploy:**
   ```bash
   eb init
   eb create production
   eb setenv EMAIL_SERVICE=gmail EMAIL_USER=your-email@gmail.com EMAIL_PASS=your-app-password COMPANY_EMAIL=contact@domain.com
   eb open
   ```

#### Option 5b: AWS EC2

1. **Launch EC2 Instance** (Ubuntu 20.04 LTS)
2. **Follow Traditional VPS steps above**
3. **Configure Security Groups** (port 80, 443, 22)

## 🔧 Pre-Deployment Checklist

### 1. Environment Configuration
- [ ] Copy `env.example` to `.env`
- [ ] Set up email service credentials
- [ ] Configure company email address
- [ ] Set NODE_ENV to production

### 2. Email Service Setup

#### Gmail Setup:
1. Enable 2-factor authentication
2. Generate app password: Google Account → Security → App passwords
3. Use app password in EMAIL_PASS

#### Other SMTP Services:
- Update `server.js` with your SMTP configuration
- Test email sending functionality

### 3. Domain Configuration
- [ ] Update all domain references from `domain.com` to your actual domain
- [ ] Update Open Graph URLs
- [ ] Update structured data URLs
- [ ] Configure DNS settings

### 4. Security Setup
- [ ] Review and update CORS settings in `server.js`
- [ ] Configure rate limiting as needed
- [ ] Set up SSL certificates
- [ ] Review CSP headers in Helmet configuration

### 5. Analytics Integration
- [ ] Add Google Analytics tracking ID (if needed)
- [ ] Configure custom analytics system
- [ ] Test tracking functionality

## 📊 Production Optimization

### Performance Optimization:
1. **Enable Compression:**
   ```javascript
   const compression = require('compression');
   app.use(compression());
   ```

2. **Static File Caching:**
   ```javascript
   app.use(express.static('public', {
     maxAge: '1y',
     etag: false
   }));
   ```

### Monitoring:
1. **Health Checks:** Already implemented at `/api/health`
2. **Logging:** Implement structured logging
3. **Error Tracking:** Consider Sentry or similar service

### Backup Strategy:
1. **Code:** Use Git with remote repository
2. **Environment:** Document all environment variables
3. **Dependencies:** Keep package-lock.json in version control

## 🚨 Troubleshooting

### Common Issues:

1. **Email Not Sending:**
   - Check Gmail app password setup
   - Verify environment variables
   - Check firewall/port restrictions

2. **CSS/JS Not Loading:**
   - Verify static file serving configuration
   - Check file paths in HTML
   - Ensure proper MIME types

3. **Form Validation Errors:**
   - Check express-validator configuration
   - Verify rate limiting settings
   - Test with different input types

### Debug Commands:
```bash
# Check server logs
pm2 logs tn-website

# Monitor server status
pm2 status

# Restart application
pm2 restart tn-website

# Test API endpoints
curl -X GET http://localhost:3000/api/health
```

## 📞 Post-Deployment Tasks

1. **Test Contact Form:**
   - Submit test message
   - Verify email delivery
   - Check auto-reply functionality

2. **Performance Testing:**
   - Test mobile responsiveness
   - Check page load speeds
   - Verify all links work

3. **SEO Verification:**
   - Submit sitemap to Google Search Console
   - Verify meta tags
   - Test social media sharing

4. **Security Audit:**
   - Run security headers check
   - Test rate limiting
   - Verify HTTPS configuration

## 🔄 Maintenance

### Regular Tasks:
- [ ] Update Node.js dependencies monthly
- [ ] Monitor server logs weekly
- [ ] Check email functionality monthly
- [ ] Review analytics data monthly
- [ ] Backup configuration files regularly

### Emergency Contacts:
- Server issues: Check PM2 logs and restart service
- Email issues: Verify SMTP credentials and service status
- Domain issues: Check DNS settings and SSL certificates

---

**Need Help?** Contact the development team or refer to the README.md for additional information. 