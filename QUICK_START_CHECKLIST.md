# Quick Start Checklist for TN Systems Hosting

## 📋 Immediate Action Items (Do Now)

### ⏰ First 30 Minutes - Account Setup
- [ ] **Go to**: https://www.ovh.com/fr/
- [ ] **Create**: Corporate account ("Entreprise")
- [ ] **Fill**: TN Systems company details + SIRET
- [ ] **Verify**: Email and phone verification
- [ ] **Login**: Access OVH Manager

### ⏰ Next 30 Minutes - Order VPS
- [ ] **Navigate**: OVH Manager → VPS section
- [ ] **Order**: VPS Essential (€7/month)
- [ ] **Select**: Ubuntu 22.04 LTS
- [ ] **Choose**: France data center (Roubaix)
- [ ] **Add**: Automated backup (+€2/month)
- [ ] **Pay**: Complete order
- [ ] **Wait**: 5-15 minutes for delivery

### ⏰ Next 60 Minutes - DNS & Email
- [ ] **Note**: VPS IP address from OVH Manager
- [ ] **Configure**: DNS for tnsystems.ai domain:
  ```
  A Record: @ → YOUR_VPS_IP
  A Record: www → YOUR_VPS_IP
  ```
- [ ] **Setup**: Gmail tnsystems.ai@gmail.com
- [ ] **Enable**: 2FA on Gmail
- [ ] **Generate**: App password (16 characters)
- [ ] **Save**: App password securely

### ⏰ Next 60 Minutes - Deployment
- [ ] **SSH**: Connect to VPS: `ssh ubuntu@YOUR_VPS_IP`
- [ ] **Upload**: Project files to VPS
- [ ] **Run**: `./deploy-production.sh`
- [ ] **Edit**: `/var/www/tn-systems/.env` with Gmail app password
- [ ] **Restart**: `pm2 restart tn-systems`
- [ ] **Test**: Visit https://tnsystems.ai

## 🚨 Critical Information to Have Ready

### Company Information for OVH:
```
- Company Name: TN Systems
- Legal Structure: [SAS/SARL/etc.]
- SIRET Number: [14-digit French company ID]
- VAT Number: FR[YourNumber] (if applicable)
- Registered Address: [Full French address]
- Phone: +33[French number]
- Admin Email: [Your email]
```

### Technical Details:
```
- Domain: tnsystems.ai (already owned ✅)
- Email: tnsystems.ai@gmail.com (need to setup)
- VPS Choice: Essential €7/month
- Location: France (Roubaix)
- OS: Ubuntu 22.04 LTS
```

## 💡 Pro Tips

### Save Time:
1. **Have documents ready**: SIRET, company registration
2. **Use strong passwords**: Save in password manager
3. **Keep terminal open**: You'll need multiple SSH sessions
4. **Test DNS propagation**: Use whatsmydns.net

### Avoid Common Mistakes:
- ❌ Don't choose "Particulier" account type
- ❌ Don't forget to enable 2FA on Gmail
- ❌ Don't skip the backup option (only €2/month)
- ❌ Don't use weak passwords

## 📞 Emergency Contacts

### If Something Goes Wrong:
- **OVH Support**: +33 9 72 10 10 07
- **OVH Help**: https://help.ovh.com/
- **DNS Check**: https://www.whatsmydns.net/
- **Gmail Help**: https://support.google.com/gmail/

## ⏰ Timeline Estimate

```
Total Time: 3 hours maximum
- Account setup: 30 minutes
- VPS order: 30 minutes
- DNS/Email setup: 60 minutes
- Deployment: 60 minutes
```

## 🎯 Success Criteria

### You're Done When:
- ✅ https://tnsystems.ai loads with SSL
- ✅ Contact form sends emails to tnsystems.ai@gmail.com
- ✅ PM2 shows "tn-systems" running
- ✅ No errors in browser console

## 🔄 If You Need Help

### Stuck on OVH Account?
- **Check**: Company documents are correct
- **Verify**: Email/phone verification completed
- **Try**: Different browser or incognito mode

### VPS Not Working?
- **Check**: DNS propagation (can take 2 hours)
- **Verify**: Firewall allows ports 80, 443
- **Test**: `ssh ubuntu@YOUR_VPS_IP` works

### Email Not Working?
- **Verify**: Gmail app password is correct
- **Check**: 2FA is enabled on Gmail
- **Test**: PM2 logs for errors: `pm2 logs tn-systems`

---

**Start here**: https://www.ovh.com/fr/ → "Créer un compte" → "Entreprise"

**Next**: Follow OVH_SETUP_GUIDE.md for detailed steps

**Ready?** Let's get TN Systems online! 🚀 