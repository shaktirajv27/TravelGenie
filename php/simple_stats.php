<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

try {
    require_once 'config.php';
    require_once 'database.php';
    
    $db = Database::getInstance();
    
    // Get users count (Happy Travelers)
    $stmt = $db->prepare("SELECT COUNT(*) as count FROM users");
    $stmt->execute();
    $userCount = $stmt->fetch()['count'] ?? 0;
    
    // Get destinations count
    $stmt = $db->prepare("SELECT COUNT(DISTINCT destination) as count FROM travel_plans WHERE destination IS NOT NULL AND destination != ''");
    $stmt->execute();
    $destCount = $stmt->fetch()['count'] ?? 0;
    
    // Get average rating
    $stmt = $db->prepare("SELECT AVG(rating) as avg_rating, COUNT(*) as total_reviews FROM user_feedback WHERE is_approved = 1");
    $stmt->execute();
    $ratingData = $stmt->fetch();
    
    echo json_encode([
        'success' => true,
        'data' => [
            'happy_travelers' => (int)$userCount,
            'destinations' => (int)$destCount,
            'user_rating' => round($ratingData['avg_rating'] ?? 4.8, 1),
            'total_reviews' => (int)($ratingData['total_reviews'] ?? 0)
        ]
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
