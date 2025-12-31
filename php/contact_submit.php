<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Start output buffering to prevent extra output
ob_start();

try {
    require_once 'config.php';
    require_once 'database.php';
    
    // Get JSON input
    $json = file_get_contents('php://input');
    $input = json_decode($json, true);
    
    if (!$input) {
        throw new Exception('Invalid JSON input received');
    }
    
    // Extract and sanitize data according to your database schema
    $firstName = trim($input['firstName'] ?? '');
    $lastName = trim($input['lastName'] ?? '');
    $email = trim($input['email'] ?? '');
    $phone = trim($input['phone'] ?? '');
    $subject = trim($input['subject'] ?? '');
    $message = trim($input['message'] ?? '');
    $newsletterOptIn = isset($input['newsletterOptIn']) && $input['newsletterOptIn'] ? 1 : 0;
    
    // Validation
    if (empty($firstName)) {
        throw new Exception('First name is required');
    }
    
    if (empty($lastName)) {
        throw new Exception('Last name is required');
    }
    
    if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new Exception('Valid email address is required');
    }
    
    if (empty($subject)) {
        throw new Exception('Subject is required');
    }
    
    if (empty($message)) {
        throw new Exception('Message is required');
    }
    
    // Insert into contacts table
    $db = Database::getInstance();
    
    $stmt = $db->prepare("
        INSERT INTO contacts (first_name, last_name, email, phone, subject, message, newsletter_opt_in, created_at, status) 
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), 1)
    ");
    
    // Clean output buffer before sending response
    ob_clean();
    
    $result = $stmt->execute([
        $firstName,
        $lastName,
        $email,
        $phone,
        $subject,
        $message,
        $newsletterOptIn
    ]);
    
    if ($result) {
        echo json_encode([
            'success' => true,
            'message' => 'Thank you for contacting us! We will get back to you within 24 hours.',
            'contact_id' => $db->lastInsertId()
        ]);
    } else {
        throw new Exception('Failed to save contact information');
    }
    
} catch (Exception $e) {
    // Clean output buffer before error response
    ob_clean();
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}

// End output buffering
ob_end_flush();
?>
