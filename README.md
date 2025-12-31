# Travel Genie - AI-Powered Travel Assistant Pro 2.0

<div align="center">

![Travel Genie Logo](https://img.shields.io/badge/Travel%20Genie-AI%20Travel%20Assistant-blue?style=for-the-badge)

**Your intelligent travel companion that creates personalized itineraries using AI**

[Features](#-features) • [Installation](#-installation--setup) • [Documentation](#-documentation) • [Support](#-support)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Installation & Setup](#-installation--setup)
- [Configuration](#-configuration)
- [Database Setup](#-database-setup)
- [API Integration](#-api-integration)
- [Usage Guide](#-usage-guide)
- [File Structure](#-file-structure)
- [Development](#-development)
- [Security Considerations](#-security-considerations)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**Travel Genie** is a comprehensive AI-powered travel planning platform that helps users create personalized travel itineraries in minutes. The application leverages Google's Gemini AI to generate detailed travel plans based on user preferences, budget, interests, and travel style.

### Key Highlights

- 🤖 **AI-Powered Planning**: Uses Google Gemini 1.5 Pro for intelligent itinerary generation
- 👤 **User Authentication**: Secure registration and login system
- 📊 **Dashboard**: Personal dashboard to manage all travel plans
- 💬 **Feedback System**: User testimonials and feedback collection
- 📱 **Responsive Design**: Mobile-optimized interface
- 🔒 **Secure**: Password hashing, session management, and data protection

---

## ✨ Features

### Core Features

1. **AI Travel Planning**
   - Personalized itinerary generation
   - Day-by-day activity planning
   - Hotel and restaurant recommendations
   - Budget breakdown and analysis
   - Hidden gems and local insights
   - Weather considerations

2. **User Management**
   - User registration and authentication
   - Secure password hashing
   - Session management
   - User profile management
   - Dashboard for saved plans

3. **Travel Plan Management**
   - Create and save travel plans
   - View plan history
   - Filter plans by status (draft, confirmed, completed)
   - Share plans with others
   - Export plans

4. **Booking Integration**
   - Direct links to booking platforms:
     - Booking.com (Hotels)
     - Expedia (Packages)
     - Kayak (Flights)
     - Airbnb (Accommodations)
   - Pre-filled search parameters

5. **Feedback & Testimonials**
   - Submit travel feedback
   - View anonymous testimonials
   - Rating system (1-5 stars)
   - Destination-based feedback

6. **Statistics Dashboard**
   - Total trips planned
   - Destinations explored
   - Upcoming trips
   - User ratings and reviews

7. **Contact & Support**
   - Contact form submission
   - Help center
   - FAQ section
   - Travel tips

---

## 🛠 Technology Stack

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Modern styling with custom properties
- **JavaScript (ES6+)**: Interactive functionality
- **Font Awesome**: Icon library
- **Google Fonts (Poppins)**: Typography

### Backend
- **PHP 7.4+**: Server-side logic
- **PDO**: Database abstraction layer
- **MySQL/MariaDB**: Relational database

### AI Integration
- **Google Gemini API**: AI-powered content generation
  - Model: `gemini-1.5-pro`
  - Endpoint: `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent`

### Additional Tools
- **Python 3.x**: Optional Gemini helper scripts
- **cURL**: HTTP requests for API calls

---

## 📁 Project Structure

```
travel-genie/
│
├── 📄 index.html                 # Main landing page
├── 📄 login.html                  # User login page
├── 📄 register.html               # User registration page
├── 📄 dashboard.html              # User dashboard
├── 📄 feedback.html               # Feedback submission page
├── 📄 contact-us.html             # Contact form page
├── 📄 about.html                  # About page
├── 📄 about-us.html               # About us page
├── 📄 faq.html                    # FAQ page
├── 📄 help-center.html            # Help center
├── 📄 travel-tips.html            # Travel tips page
├── 📄 privacy-policy.html         # Privacy policy
├── 📄 terms-of-service.html       # Terms of service
├── 📄 careers.html                 # Careers page
│
├── 📂 css/
│   ├── style.css                  # Main stylesheet
│   ├── auth.css                   # Authentication pages styles
│   ├── dashboard.css               # Dashboard styles
│   └── about.css                  # About page styles
│
├── 📂 js/
│   ├── script.js                  # Main JavaScript functionality
│   ├── auth.js                    # Authentication logic
│   └── dashboard.js               # Dashboard functionality
│
├── 📂 php/
│   ├── config.php                 # Configuration file (API keys, DB credentials)
│   ├── database.php               # Database connection class
│   ├── auth.php                   # Authentication system
│   ├── travel_planner.php         # Travel plan creation and management
│   ├── gemini_api.php             # Gemini API integration
│   ├── submit_feedback.php        # Feedback submission handler
│   ├── latest_feedback.php        # Fetch latest testimonials
│   ├── simple_stats.php           # Statistics API
│   ├── contact_submit.php         # Contact form handler
│   └── booking_redirect.php      # Booking redirect handler
│
├── 📂 database/
│   └── schema.sql                 # Database schema and migrations
│
├── 📂 python/
│   └── gemini_helper.py           # Python helper for Gemini API
│
├── 📂 assets/
│   ├── images/
│   │   ├── hero-bg.jpg            # Hero section background
│   │   ├── features/              # Feature images
│   │   └── testimonials/          # Testimonial images
│   └── icons/                     # Custom icons
│
└── 📄 README.md                   # This file
```

---

## 🚀 Installation & Setup

### Prerequisites

- **Web Server**: Apache or Nginx
- **PHP**: Version 7.4 or higher
- **MySQL/MariaDB**: Version 5.7 or higher
- **Python 3.x** (optional, for Python helper scripts)
- **Google Gemini API Key** (Get from [Google AI Studio](https://makersuite.google.com/app/apikey))

### Step 1: Clone or Download the Project

```bash
# If using Git
git clone <repository-url>
cd travel-genie

# Or download and extract the ZIP file
```

### Step 2: Configure Web Server

#### Apache Configuration

1. Place the project in your web server directory:
   - **Windows**: `C:\xampp\htdocs\travel-genie\`
   - **Linux/Mac**: `/var/www/html/travel-genie/`

2. Ensure `mod_rewrite` is enabled (if using URL rewriting)

3. Create a virtual host (optional but recommended):

```apache
<VirtualHost *:80>
    ServerName travelgenie.local
    DocumentRoot "C:/xampp/htdocs/travel-genie"
    <Directory "C:/xampp/htdocs/travel-genie">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

#### Nginx Configuration

```nginx
server {
    listen 80;
    server_name travelgenie.local;
    root /var/www/html/travel-genie;
    index index.html index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

### Step 3: Database Setup

1. **Create Database**:

```sql
CREATE DATABASE travel_assistant;
```

2. **Import Schema**:

```bash
# Using MySQL command line
mysql -u root -p travel_assistant < database/schema.sql

# Or using phpMyAdmin
# Navigate to phpMyAdmin → Import → Select schema.sql
```

3. **Verify Tables**:

The following tables should be created:
- `users` - User accounts
- `travel_plans` - Travel itineraries
- `bookings` - Booking records
- `user_sessions` - Session management
- `user_preferences` - User preferences
- `user_feedback` - Feedback and testimonials
- `contacts` - Contact form submissions

### Step 4: Configuration

Edit `php/config.php` with your settings:

```php
<?php
// API Configuration
define('GEMINI_API_KEY', 'YOUR_GEMINI_API_KEY_HERE');

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'travel_assistant');
define('DB_USER', 'root');
define('DB_PASS', 'your_password');
?>
```

**⚠️ Important**: 
- Replace `YOUR_GEMINI_API_KEY_HERE` with your actual Gemini API key
- Update database credentials as needed
- Never commit `config.php` with real credentials to version control

### Step 5: Set Permissions

```bash
# Linux/Mac
chmod 755 php/
chmod 644 php/*.php

# Ensure PHP can write to necessary directories (if any)
```

### Step 6: Test Installation

1. Start your web server and MySQL
2. Open browser: `http://localhost/travel-genie/`
3. You should see the Travel Genie homepage
4. Try registering a new account
5. Test creating a travel plan

---

## ⚙️ Configuration

### Environment Variables

All configuration is done in `php/config.php`:

| Variable | Description | Example |
|----------|-------------|---------|
| `GEMINI_API_KEY` | Google Gemini API key | `AIzaSy...` |
| `DB_HOST` | Database host | `localhost` |
| `DB_NAME` | Database name | `travel_assistant` |
| `DB_USER` | Database username | `root` |
| `DB_PASS` | Database password | `password123` |

### API Configuration

The Gemini API is configured in `php/gemini_api.php`:

- **Model**: `gemini-1.5-pro`
- **Temperature**: `0.7` (creativity level)
- **Max Tokens**: `2048` (response length)
- **Timeout**: `30 seconds`

### Session Configuration

Sessions are managed via PHP's native session system:
- Session lifetime: Default PHP session timeout
- Session storage: Server-side (file-based or database)

---

## 🗄️ Database Setup

### Database Schema

The complete schema is in `database/schema.sql`. Key tables:

#### Users Table
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Travel Plans Table
```sql
CREATE TABLE travel_plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    destination VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    budget_range VARCHAR(20),
    travel_type VARCHAR(20),
    interests JSON,
    ai_response LONGTEXT,
    status ENUM('draft', 'confirmed', 'completed'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### User Feedback Table
```sql
CREATE TABLE user_feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    rating INT NOT NULL,
    feedback_text TEXT NOT NULL,
    travel_destination VARCHAR(100),
    is_approved BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Database Indexes

The schema includes indexes for performance:
- `idx_users_email` on `users(email)`
- `idx_travel_plans_user_id` on `travel_plans(user_id)`
- `idx_bookings_user_id` on `bookings(user_id)`
- `idx_sessions_token` on `user_sessions(session_token)`

---

## 🔌 API Integration

### Google Gemini API

The application uses Google's Gemini API for AI-powered travel planning.

#### Getting API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Create a new API key
4. Copy the key to `php/config.php`

#### API Usage

The Gemini API is called through `php/gemini_api.php`:

```php
$gemini = new GeminiAPI();
$response = $gemini->createTravelPlan(
    $destination,
    $duration,
    $budget,
    $interests,
    $travelType
);
```

#### Rate Limits

- Free tier: Check Google's current limits
- Paid tier: Higher rate limits available
- Implement caching for production use

### Booking APIs

The application provides redirect links to:
- **Booking.com**: Hotel bookings
- **Expedia**: Travel packages
- **Kayak**: Flight searches
- **Airbnb**: Accommodations

These are external links, not API integrations.

---

## 📖 Usage Guide

### For End Users

#### 1. Registration

1. Navigate to `register.html`
2. Fill in:
   - Username (3-20 characters)
   - Email address
   - Password (minimum 8 characters)
   - First and last name
   - Phone number (optional)
3. Accept terms of service
4. Click "Create Account"

#### 2. Login

1. Go to `login.html`
2. Enter email and password
3. Click "Sign In"
4. You'll be redirected to the dashboard

#### 3. Create Travel Plan

1. From homepage, scroll to "Travel Planner" section
2. Fill in:
   - **Destination**: Where you want to go
   - **Duration**: Number of days (3-30)
   - **Budget**: Budget range (Budget/Mid-range/Luxury)
   - **Travel Style**: Solo/Couple/Family/Friends/Business
   - **Interests**: Select multiple (Adventure, Culture, Food, etc.)
3. Click "Generate My Perfect Trip"
4. Wait for AI to generate your plan (30-60 seconds)
5. Review the generated itinerary
6. Save or share your plan

#### 4. Dashboard

1. Access dashboard from navigation or `dashboard.html`
2. View all your travel plans
3. Filter by status (All/Draft/Confirmed/Completed)
4. Click on a plan to view details
5. Share or book from plan cards

#### 5. Submit Feedback

1. Navigate to `feedback.html`
2. Fill in:
   - Name
   - Email
   - Destination (optional)
   - Rating (1-5 stars)
   - Feedback text
3. Submit feedback
4. Your feedback will appear in testimonials (anonymized)

### For Developers

#### Creating a Travel Plan Programmatically

```javascript
const travelData = {
    destination: "Paris, France",
    duration: 7,
    budget: "mid-range",
    travelType: "couple",
    interests: ["culture", "food", "history"]
};

fetch('php/travel_planner.php', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(travelData)
})
.then(response => response.json())
.then(data => {
    console.log('Travel plan:', data);
});
```

#### Authentication Check

```javascript
fetch('php/auth.php', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({ action: 'check' })
})
.then(response => response.json())
.then(data => {
    if (data.success && data.user) {
        console.log('Logged in as:', data.user);
    }
});
```

---

## 🔧 Development

### Local Development Setup

1. **Install XAMPP/WAMP/MAMP** (for Windows/Mac)
   - Includes Apache, PHP, and MySQL

2. **Enable Required PHP Extensions**:
   ```ini
   extension=pdo_mysql
   extension=curl
   extension=json
   extension=session
   ```

3. **Development Mode**:
   - Enable error reporting in `php/config.php`:
   ```php
   ini_set('display_errors', 1);
   error_reporting(E_ALL);
   ```

### Code Structure

#### Frontend Architecture

- **HTML**: Semantic, accessible markup
- **CSS**: Modular stylesheets per page/component
- **JavaScript**: 
  - `script.js`: Main application logic
  - `auth.js`: Authentication handlers
  - `dashboard.js`: Dashboard functionality

#### Backend Architecture

- **MVC-like Structure**:
  - Models: Database classes (`database.php`)
  - Controllers: PHP endpoints (`auth.php`, `travel_planner.php`)
  - Views: HTML templates

- **Class-based Design**:
  - `Database`: Singleton pattern for DB connections
  - `AuthSystem`: Authentication logic
  - `GeminiAPI`: AI integration
  - `EnhancedTravelPlanner`: Travel plan management

### Adding New Features

#### Adding a New API Endpoint

1. Create new PHP file in `php/` directory
2. Include required files:
   ```php
   require_once 'config.php';
   require_once 'database.php';
   ```
3. Handle requests:
   ```php
   if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       // Your logic here
   }
   ```
4. Return JSON:
   ```php
   header('Content-Type: application/json');
   echo json_encode(['success' => true, 'data' => $data]);
   ```

#### Adding a New Page

1. Create HTML file in root directory
2. Include navigation and footer from `index.html`
3. Link CSS in `<head>`
4. Add JavaScript before closing `</body>`

### Testing

#### Manual Testing Checklist

- [ ] User registration
- [ ] User login/logout
- [ ] Travel plan creation
- [ ] Dashboard functionality
- [ ] Feedback submission
- [ ] Contact form
- [ ] Responsive design (mobile/tablet/desktop)
- [ ] Cross-browser compatibility

#### Database Testing

```sql
-- Test user creation
SELECT * FROM users;

-- Test travel plan creation
SELECT * FROM travel_plans;

-- Test feedback
SELECT * FROM user_feedback;
```

---

## 🔒 Security Considerations

### Current Security Measures

1. **Password Security**:
   - Passwords hashed using `password_hash()` (bcrypt)
   - Minimum 8 characters required
   - Password strength validation

2. **SQL Injection Prevention**:
   - All queries use PDO prepared statements
   - No direct string concatenation in SQL

3. **Session Management**:
   - PHP sessions for authentication
   - Session validation on protected pages

4. **Input Validation**:
   - Server-side validation in PHP
   - Client-side validation in JavaScript
   - Email format validation
   - XSS prevention through output escaping

### Security Recommendations

1. **API Key Protection**:
   - ⚠️ **IMPORTANT**: Never commit `config.php` with real API keys
   - Use environment variables in production
   - Restrict API key permissions

2. **HTTPS**:
   - Use HTTPS in production
   - Configure SSL certificates

3. **Database Security**:
   - Use strong database passwords
   - Limit database user permissions
   - Regular backups

4. **Rate Limiting**:
   - Implement rate limiting for API calls
   - Prevent abuse of travel plan generation

5. **CSRF Protection**:
   - Add CSRF tokens to forms
   - Validate tokens on submission

6. **File Upload Security** (if adding):
   - Validate file types
   - Scan for malware
   - Store outside web root

### Security Checklist

- [ ] Change default database credentials
- [ ] Use strong passwords
- [ ] Enable HTTPS
- [ ] Keep PHP and MySQL updated
- [ ] Regular security audits
- [ ] Monitor error logs
- [ ] Backup database regularly

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Database Connection Error

**Error**: `Database connection failed`

**Solutions**:
- Check database credentials in `php/config.php`
- Verify MySQL service is running
- Check database exists: `SHOW DATABASES;`
- Verify user permissions

#### 2. Gemini API Error

**Error**: `API request failed with status: 400`

**Solutions**:
- Verify API key is correct in `config.php`
- Check API key has proper permissions
- Verify internet connection
- Check API quota/limits

#### 3. Session Not Working

**Error**: User logged out immediately

**Solutions**:
- Check PHP session configuration
- Verify `session_start()` is called
- Check file permissions on session directory
- Clear browser cookies

#### 4. Travel Plan Not Generating

**Error**: `Failed to generate travel plan`

**Solutions**:
- Check API key is valid
- Verify all form fields are filled
- Check PHP error logs
- Verify database connection

#### 5. Feedback Not Displaying

**Error**: Testimonials not showing

**Solutions**:
- Check `user_feedback` table exists
- Verify `is_approved = 1` in database
- Check `latest_feedback.php` for errors
- Verify database connection

### Debug Mode

Enable debug mode in `php/config.php`:

```php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
```

### Log Files

Check these locations for errors:
- **Apache**: `/var/log/apache2/error.log` (Linux) or `C:\xampp\apache\logs\error.log` (Windows)
- **PHP**: Check `php.ini` for `error_log` location
- **MySQL**: Check MySQL error log

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit your changes**:
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch**:
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Contribution Guidelines

- Follow existing code style
- Write clear commit messages
- Add comments for complex logic
- Test your changes
- Update documentation if needed

### Areas for Contribution

- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 🎨 UI/UX enhancements
- 🔒 Security improvements
- ⚡ Performance optimizations
- 🌐 Translations

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

**Note**: This project includes:
- Google Gemini API integration (subject to Google's terms)
- Font Awesome icons (subject to Font Awesome license)
- Google Fonts (subject to Google Fonts license)

---

## 📞 Support

### Getting Help

- **Documentation**: Check this README first
- **Issues**: Open an issue on GitHub
- **Email**: Contact through the contact form on the website

### Resources

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)

---

## 🎉 Acknowledgments

- **Google Gemini**: For AI-powered content generation
- **Font Awesome**: For beautiful icons
- **Google Fonts**: For typography
- **Open Source Community**: For inspiration and tools

---

## 📊 Project Status

**Version**: 2.0  
**Status**: Active Development  
**Last Updated**: 2025

### Current Features
- ✅ User Authentication
- ✅ AI Travel Planning
- ✅ Dashboard
- ✅ Feedback System
- ✅ Contact Forms
- ✅ Responsive Design

### Planned Features
- 🔄 Weather Integration
- 🔄 Social Login (Google, Facebook)
- 🔄 Email Notifications
- 🔄 PDF Export
- 🔄 Mobile App
- 🔄 Multi-language Support

---

## 🌟 Star History

If you find this project useful, please consider giving it a star ⭐!

---

<div align="center">

**Made with ❤️ by the Travel Genie Team**

[⬆ Back to Top](#travel-genie---ai-powered-travel-assistant-pro-20)

</div>

