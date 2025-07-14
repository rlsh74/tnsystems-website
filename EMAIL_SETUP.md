# Email Setup Guide for TN Systems

## Gmail Configuration: tnsystems.ai@gmail.com

### 1. Gmail Account Setup

#### If account doesn't exist:
1. Go to https://accounts.google.com/signup
2. Create account with email: `tnsystems.ai@gmail.com`
3. Complete account verification

#### If account exists:
1. Log into `tnsystems.ai@gmail.com`
2. Proceed to security setup

### 2. Enable 2-Factor Authentication

1. Go to **Google Account Settings**: https://myaccount.google.com/
2. Click **Security** in the left menu
3. Under **Signing in to Google**, click **2-Step Verification**
4. Follow setup instructions (use phone number or authenticator app)
5. **Complete 2FA setup** - this is required for app passwords

### 3. Generate App Password

1. Still in **Security** settings
2. Under **Signing in to Google**, click **App passwords**
   - If you don't see this option, ensure 2FA is enabled first
3. Select app: **Mail**
4. Select device: **Other (Custom name)**
5. Enter name: `TN Systems Website`
6. Click **Generate**
7. **Copy the 16-character password** (example: `abcd efgh ijkl mnop`)

### 4. Update Server Configuration

Update the `.env` file on your server:

```env
# Email Configuration
NODE_ENV=production
PORT=3000
FRONTEND_URL=https://tnsystems.ai
EMAIL_SERVICE=gmail
EMAIL_USER=tnsystems.ai@gmail.com
EMAIL_PASS=abcd-efgh-ijkl-mnop  # Replace with your app password
COMPANY_EMAIL=tnsystems.ai@gmail.com
```

### 5. Test Email Configuration

#### After deployment, test the contact form:
1. Visit `https://tnsystems.ai`
2. Fill out the contact form
3. Submit the form
4. Check `tnsystems.ai@gmail.com` for:
   - **Company notification** (new contact form submission)
   - **User confirmation** should be sent to the form submitter

### 6. Email Templates

The system sends two emails per contact form submission:

#### A) Company Notification Email:
- **To**: tnsystems.ai@gmail.com
- **Subject**: New Contact Form Submission - TN Systems
- **Content**: Full contact details and message

#### B) User Confirmation Email:
- **To**: Form submitter's email
- **Subject**: Thank you for contacting TN Systems
- **Content**: Confirmation and next steps

### 7. Gmail Organization Tips

#### Create Labels for Better Organization:
1. In Gmail, click **Create new label**
2. Create labels:
   - `TN Systems - Contact Forms`
   - `TN Systems - Website`

#### Set up Filters:
1. Click **Settings** → **Filters and Blocked Addresses**
2. Create filter:
   - **From**: your-server-email
   - **Subject**: contains "TN Systems"
   - **Action**: Apply label "TN Systems - Contact Forms"

### 8. Security Best Practices

#### Recommended Settings:
- **Enable**: Less secure app access (if needed)
- **Enable**: IMAP access (for better email management)
- **Review**: Recent security activity regularly
- **Use**: Strong, unique password for Gmail account

#### Monitor Account Activity:
- Regular security checkups
- Review recent activity
- Monitor for unauthorized access

### 9. Troubleshooting

#### Common Issues:

**Email not sending:**
- Check app password is correct
- Verify 2FA is enabled
- Check server logs: `pm2 logs tn-systems`

**Email going to spam:**
- Add server IP to SPF record
- Consider setting up DKIM
- Use professional email signature

**Gmail blocking emails:**
- Verify account security
- Check for unusual activity alerts
- Temporarily disable security features if needed

### 10. Production Checklist

Before going live:
- ✅ Gmail account `tnsystems.ai@gmail.com` created
- ✅ 2-Factor Authentication enabled
- ✅ App password generated
- ✅ Server `.env` file updated
- ✅ Contact form tested
- ✅ Email delivery confirmed
- ✅ Gmail labels/filters set up
- ✅ Security monitoring enabled

### Support

For email-related issues:
- **Gmail Help**: https://support.google.com/gmail/
- **Server logs**: `pm2 logs tn-systems`
- **Test email**: Use contact form on website

---

**Note**: Keep your app password secure and don't share it. If compromised, generate a new one immediately. 