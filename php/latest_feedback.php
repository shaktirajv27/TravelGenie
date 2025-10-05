<?php
// Enable full error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set headers
header('Content-Type: application/json');
header('Cache-Control: no-cache, must-revalidate');

// Start output buffering to prevent extra output
ob_start();

try {
    // Check if files exist
    if (!file_exists('config.php')) {
        throw new Exception('config.php file not found');
    }
    
    if (!file_exists('database.php')) {
        throw new Exception('database.php file not found');
    }
    
    require_once 'config.php';
    require_once 'database.php';
    
    // Test database connection
    $db = Database::getInstance();
    
    if (!$db) {
        throw new Exception('Database connection failed');
    }
    
    // Check if table exists
    $stmt = $db->prepare("SHOW TABLES LIKE 'user_feedback'");
    $stmt->execute();
    $tableExists = $stmt->fetch();
    
    if (!$tableExists) {
        throw new Exception('user_feedback table does not exist');
    }
    
    // Get latest 3 approved feedback
    $stmt = $db->prepare("
        SELECT name, rating, feedback_text, travel_destination, created_at 
        FROM user_feedback 
        WHERE is_approved = 1 
        ORDER BY created_at DESC 
        LIMIT 3
    ");
    
    $stmt->execute();
    $feedback = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Clean output buffer
    ob_clean();
    
    // Return success response
    echo json_encode([
        'success' => true,
        'data' => $feedback,
        'count' => count($feedback),
        'debug' => 'API working correctly'
    ], JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    // Clean output buffer
    ob_clean();
    
    // Return detailed error for debugging
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString(),
        'data' => []
    ]);
}

// End output buffering
ob_end_flush();
?>
