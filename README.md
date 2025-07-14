# TN Systems Website

A modern, minimalist website for TN Systems - a French company specializing in intellectual Knowledge Bases for creating Virtual (Non-Human) workers across Pharma, LifeScience, Medicine, and Fintech industries.

## 🚀 Features

- **Modern Design**: Clean, minimalist interface with light footer design
- **Official Branding**: Integrated TN Systems logo with optimized visibility
- **Responsive Layout**: Works perfectly on desktop, tablet, and mobile devices
- **Contact Form**: Integrated contact form with email notifications
- **SEO Optimized**: Search engine friendly with structured data and meta tags
- **Analytics Ready**: Prepared for Google Analytics and custom analytics integration
- **Security**: Built-in security measures including rate limiting and input validation
- **Performance**: Optimized for fast loading and smooth user experience
- **Professional Typography**: Inter font for body text, Poppins for headings

## 🛠️ Tech Stack

### Frontend
- **HTML5**: Semantic markup with accessibility features
- **CSS3**: Modern styling with CSS Grid, Flexbox, and CSS variables
- **JavaScript**: Vanilla JS for interactivity and form handling
- **Google Fonts**: Inter and Poppins font families for clean typography

### Backend
- **Node.js**: Server-side JavaScript runtime
- **Express.js**: Web application framework with static file serving
- **Nodemailer**: Email sending functionality
- **Security**: Helmet, CORS, rate limiting, input validation

### Dependencies
- `express`: Web framework
- `nodemailer`: Email functionality
- `cors`: Cross-origin resource sharing
- `helmet`: Security middleware
- `express-rate-limit`: Rate limiting
- `express-validator`: Input validation
- `dotenv`: Environment variable management

## 📁 Project Structure

```
tn-systems-website/
├── index.html              # Main HTML file
├── server.js               # Backend server
├── package.json            # Node.js dependencies
├── package-lock.json       # Dependency lock file
├── env.example             # Environment variables example
├── README.md               # Project documentation
├── SYSTEM_REVIEW.md        # Development progress tracking
├── DEPLOYMENT.md           # Comprehensive deployment guide
├── Dockerfile              # Docker configuration
├── vercel.json             # Vercel deployment config
├── netlify.toml            # Netlify deployment config
├── .gitignore              # Git ignore rules
└── public/                 # Static assets directory
    ├── styles.css          # CSS styling (11KB)
    ├── script.js           # Frontend JavaScript (11KB)
    ├── favicon.ico         # ICO favicon
    ├── favicon.svg         # SVG favicon
    └── images/
        └── TNS_logo.png    # Official TN Systems logo (18KB)
```

## 🚀 Quick Start

### Prerequisites
- Node.js (version 16 or higher)
- npm (comes with Node.js)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/tn-systems/website.git
   cd tn-systems-website
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp env.example .env
   ```
   Edit `.env` with your email configuration:
   ```env
   NODE_ENV=development
   PORT=3000
   EMAIL_SERVICE=gmail
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   COMPANY_EMAIL=contact@domain.com
   ```

4. **Start the development server**
   ```bash
   npm start
   ```

5. **Open in browser**
   Visit `http://localhost:3000`

## 📧 Email Configuration

### Gmail Setup (Recommended)
1. Enable 2-factor authentication on your Gmail account
2. Generate an app password: Google Account → Security → App passwords
3. Use the app password in your `.env` file

### Other Email Providers
Configure SMTP settings in your `.env` file:
```env
SMTP_HOST=smtp.your-provider.com
SMTP_PORT=587
SMTP_USER=your-smtp-user
SMTP_PASS=your-smtp-password
```

## 🔧 Available Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server (same as start)
- `npm test` - Run tests (placeholder)

## 🎨 Design & Styling

### Color Scheme
```css
:root {
    --primary-color: #2563eb;      /* Primary blue */
    --primary-hover: #1d4ed8;      /* Darker blue for hover */
    --secondary-color: #64748b;    /* Secondary gray */
    --accent-color: #0f172a;       /* Dark accent (header) */
    --text-primary: #1e293b;       /* Primary text */
    --text-secondary: #64748b;     /* Secondary text */
    --text-light: #94a3b8;         /* Light text */
    --background-primary: #ffffff;  /* White background */
    --background-secondary: #f8fafc; /* Light gray (footer) */
    --border-color: #e2e8f0;       /* Border color */
}
```

### Typography
- **Headings**: Poppins font family (700, 600, 500 weights)
- **Body Text**: Inter font family (400, 500, 600 weights)
- **Logo**: Official TN Systems PNG logo in header and footer

### Layout
- **Header**: Dark background with white logo and navigation
- **Hero Section**: Centered content with call-to-action buttons
- **Content Sections**: White background with proper spacing
- **Footer**: Light gray background for better logo visibility

## 📱 Responsive Design

The website is fully responsive and optimized for:
- **Desktop**: 1200px and above
- **Tablet**: 768px to 1199px
- **Mobile**: 320px to 767px

### Breakpoints
- `768px`: Main responsive breakpoint
- `480px`: Mobile-specific adjustments

## 🔒 Security Features

- **Helmet**: Security headers and CSP
- **CORS**: Cross-origin resource sharing protection
- **Rate Limiting**: 5 requests per 15 minutes for contact form
- **Input Validation**: Server-side form validation with express-validator
- **Content Security Policy**: XSS protection with specific directives

## 📊 SEO Optimization

### Meta Tags
- Title, description, keywords optimization
- Open Graph tags for social media sharing
- Twitter Card optimization
- Viewport and charset declarations

### Structured Data
```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "TN Systems",
  "description": "Intellectual Knowledge Bases for Virtual Workers",
  "url": "https://domain.com"
}
```

### Performance
- Optimized CSS and JavaScript delivery
- Compressed images and assets
- Efficient font loading
- Semantic HTML structure

## 🎯 Analytics Integration

The website is prepared for:
- **Google Analytics 4**: Ready for GA4 integration
- **Custom Analytics**: Event tracking setup
- **Form Analytics**: Contact form submission tracking
- **Performance Monitoring**: Page load and interaction tracking

### Event Tracking Points
- Contact form submissions
- Button clicks (Get Started, Learn More)
- Navigation interactions
- Scroll depth monitoring

## 🚀 Deployment

### Environment Setup
```env
NODE_ENV=production
PORT=80
EMAIL_SERVICE=gmail
EMAIL_USER=your-production-email@gmail.com
EMAIL_PASS=your-production-app-password
COMPANY_EMAIL=contact@domain.com
```

### Quick Deploy Options

#### Option 1: Vercel (Recommended)
```bash
npm i -g vercel
vercel
```

#### Option 2: Docker
```bash
docker build -t tn-systems .
docker run -p 80:3000 tn-systems
```

#### Option 3: Traditional Server
```bash
npm install --production
npm start
```

### Hosting Options
- **Vercel**: Serverless deployment (recommended)
- **Netlify**: Static hosting with serverless functions
- **DigitalOcean**: App Platform or Droplets
- **AWS**: EC2, Elastic Beanstalk, or Lambda
- **Any VPS**: Docker or direct Node.js deployment

## 🔧 Customization

### Logo Replacement
Replace `public/images/TNS_logo.png` with your logo:
- Recommended size: 280x60px
- Format: PNG with transparent background
- Update references in `index.html` if needed

### Colors
Update CSS variables in `public/styles.css`:
```css
:root {
    --primary-color: #your-primary-color;
    --background-secondary: #your-footer-background;
    /* ... other variables ... */
}
```

### Content
- Edit `index.html` for content changes
- Update company information in hero and about sections
- Modify services in the Services section
- Update contact information

### Email Templates
Customize email templates in `server.js`:
- Company notification email format
- User auto-reply email content

## 📝 Development Notes

### Code Quality
- All code comments are in English
- Semantic HTML for accessibility
- Progressive enhancement approach
- Mobile-first responsive design
- Performance optimized asset delivery

### File Organization
- HTML: Semantic structure with proper headings
- CSS: Organized with CSS variables and modular sections
- JavaScript: Vanilla JS with proper event handling
- Images: Optimized and properly sized

### Static File Serving
Files are served via Express static middleware:
- CSS: `/public/styles.css`
- JavaScript: `/public/script.js`
- Images: `/public/images/`
- Favicon: `/public/favicon.ico`

## 🌐 Domain Configuration

When deploying to `tnsystems.ai`:
1. Domain references already updated in `index.html`
2. Configure DNS settings (A records, CNAME)
3. Set up SSL certificate
4. Update environment variables
5. Test email delivery to `tnsystems.ai@gmail.com`

## 📞 Support

For support and questions:
- **Email**: tnsystems.ai@gmail.com
- **Documentation**: README.md and DEPLOYMENT.md
- **System Review**: SYSTEM_REVIEW.md

## 📄 License

This project is licensed under the MIT License.

## 🏢 About TN Systems

TN Systems is a French company specializing in the implementation of intellectual Knowledge Bases for creating Virtual (Non-Human) workers including Virtual Analysts, Scientists, and other specialized roles for industries such as Pharma, LifeScience, Medicine, and Fintech.

### Company Mission
To eliminate bottlenecks in critical industries by deploying virtual experts that accelerate drug discovery, financial analysis, and scientific research—turning months of work into days.

### Target Industries
- **Pharma**: Drug discovery and clinical research
- **LifeScience**: Biotechnology and research
- **Medicine**: Healthcare analysis and diagnostics
- **Fintech**: Financial analysis and risk assessment

---

**Last Updated**: January 2025  
**Version**: 1.0.0  
**Status**: Production Ready ✅

**Recent Updates**:
- ✅ Integrated official TN Systems logo
- ✅ Improved footer design for better branding
- ✅ Optimized static file serving
- ✅ Enhanced cross-browser compatibility
- ✅ Final production testing completed 