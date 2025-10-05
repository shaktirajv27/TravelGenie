<?php
// API Configuration
define('GEMINI_API_KEY', 'AIzaSyCYjcOS21SPnbMXNXy9CjMkQLU84tYu-A4');

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'travel_assistant');
define('DB_USER', 'root');
define('DB_PASS', '');

// Start session only if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
?>