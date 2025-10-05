<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

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
    
    // Validate and sanitize input
    $name = trim($input['name'] ?? '');
    $email = trim($input['email'] ?? '');
    $destination = trim($input['destination'] ?? '');
    $rating = (int)($input['rating'] ?? 0);
    $feedback = trim($input['feedback'] ?? '');
    
    // Validation
    if (empty($name)) {
        throw new Exception('Name is required');
    }
    
    if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new Exception('Valid email is required');
    }
    
    if ($rating < 1 || $rating > 5) {
        throw new Exception('Rating must be between 1 and 5');
    }
    
    if (empty($feedback)) {
        throw new Exception('Feedback is required');
    }
    
    // Insert into database
    $db = Database::getInstance();
    
    $stmt = $db->prepare("
        INSERT INTO user_feedback (name, email, rating, feedback_text, travel_destination, profile_image, is_approved, created_at) 
        VALUES (?, ?, ?, ?, ?, ?, 1, NOW())
    ");
    
    // Generate avatar URL
    $avatarUrl = "https://ui-avatars.com/api/?name=" . urlencode($name) . "&size=150&background=667eea&color=ffffff";
    
    // Clean output buffer before sending response
    ob_clean();
    
    $result = $stmt->execute([
        $name,
        $email, 
        $rating,
        $feedback,
        $destination ?: null,
        $avatarUrl
    ]);
    
    if ($result) {
        echo json_encode([
            'success' => true,
            'message' => 'Feedback submitted successfully',
            'feedback_id' => $db->lastInsertId()
        ]);
    } else {
        throw new Exception('Failed to save feedback to database');
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
