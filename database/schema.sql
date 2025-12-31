-- Create database
CREATE DATABASE IF NOT EXISTS travel_assistant;
USE travel_assistant;

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    preferences JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Travel plans table
CREATE TABLE travel_plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    destination VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    budget_range VARCHAR(20),
    travel_type VARCHAR(20),
    interests JSON,
    ai_response LONGTEXT,
    plan_data JSON,
    status ENUM('draft', 'confirmed', 'completed') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bookings table
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    travel_plan_id INT,
    booking_type ENUM('hotel', 'flight', 'activity', 'restaurant'),
    provider VARCHAR(50),
    booking_reference VARCHAR(100),
    booking_data JSON,
    amount DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (travel_plan_id) REFERENCES travel_plans(id) ON DELETE SET NULL
);

-- User sessions table
CREATE TABLE user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_travel_plans_user_id ON travel_plans(user_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_sessions_expires ON user_sessions(expires_at);



-- Add columns to existing users table for profile settings
ALTER TABLE users 
ADD COLUMN profile_picture VARCHAR(255) DEFAULT NULL,
ADD COLUMN bio TEXT DEFAULT NULL,
ADD COLUMN date_of_birth DATE DEFAULT NULL,
ADD COLUMN gender ENUM('male', 'female', 'other', 'prefer_not_to_say') DEFAULT NULL,
ADD COLUMN country VARCHAR(100) DEFAULT NULL,
ADD COLUMN city VARCHAR(100) DEFAULT NULL,
ADD COLUMN website VARCHAR(255) DEFAULT NULL,
ADD COLUMN linkedin VARCHAR(255) DEFAULT NULL,
ADD COLUMN twitter VARCHAR(255) DEFAULT NULL,
ADD COLUMN facebook VARCHAR(255) DEFAULT NULL;

-- Create user preferences table
CREATE TABLE user_preferences (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    theme VARCHAR(20) DEFAULT 'light',
    language VARCHAR(10) DEFAULT 'en',
    currency VARCHAR(5) DEFAULT 'USD',
    notifications_email BOOLEAN DEFAULT TRUE,
    notifications_push BOOLEAN DEFAULT TRUE,
    newsletter_subscription BOOLEAN DEFAULT TRUE,
    privacy_profile ENUM('public', 'private', 'friends') DEFAULT 'public',
    default_travel_type VARCHAR(20) DEFAULT 'solo',
    preferred_budget VARCHAR(20) DEFAULT 'mid-range',
    favorite_destinations JSON DEFAULT NULL,
    dietary_restrictions JSON DEFAULT NULL,
    accessibility_needs TEXT DEFAULT NULL,
    time_format ENUM('12h', '24h') DEFAULT '12h',
    date_format VARCHAR(20) DEFAULT 'Y-m-d',
    distance_unit ENUM('km', 'miles') DEFAULT 'km',
    temperature_unit ENUM('celsius', 'fahrenheit') DEFAULT 'celsius',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_preference (user_id)
);


CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Non-binary', 'Prefer not to say'),
    nationality VARCHAR(100),
    preferred_language VARCHAR(50) DEFAULT 'English',
    timezone VARCHAR(100) DEFAULT 'UTC',
    currency VARCHAR(10) DEFAULT 'USD',
    bio TEXT,
    occupation VARCHAR(100),
    company VARCHAR(100),
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
