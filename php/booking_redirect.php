<?php
require_once 'auth.php';
require_once 'database.php';

class BookingRedirectHandler {
    private $db;
    private $auth;
    
    public function __construct() {
        $this->db = Database::getInstance();
        $this->auth = new AuthSystem();
    }
    
    public function trackBookingClick($planId, $provider, $bookingType) {
        $user = $this->auth->getCurrentUser();
        if (!$user) {
            throw new Exception('User not authenticated');
        }
        
        // Log booking click for analytics
        $stmt = $this->db->prepare("
            INSERT INTO bookings (user_id, travel_plan_id, booking_type, provider, status) 
            VALUES (?, ?, ?, ?, 'pending')
        ");
        $stmt->execute([$user['id'], $planId, $bookingType, $provider]);
        
        return $this->db->lastInsertId();
    }
    
    public function getBookingUrl($provider, $planData) {
        $destination = urlencode($planData['destination']);
        $checkIn = date('Y-m-d', strtotime('+7 days'));
        $checkOut = date('Y-m-d', strtotime('+' . (7 + $planData['duration']) . ' days'));
        
        $urls = [
            'booking_com' => "https://www.booking.com/searchresults.html?ss={$destination}&checkin={$checkIn}&checkout={$checkOut}&group_adults=2",
            'expedia' => "https://www.expedia.com/Hotel-Search?destination={$destination}&startDate={$checkIn}&endDate={$checkOut}",
            'kayak_flights' => "https://www.kayak.com/flights/{$destination}?depart={$checkIn}&return={$checkOut}",
            'skyscanner' => "https://www.skyscanner.com/flights-to/{$destination}",
            'tripadvisor' => "https://www.tripadvisor.com/Hotels-g-{$destination}",
            'airbnb' => "https://www.airbnb.com/s/{$destination}?checkin={$checkIn}&checkout={$checkOut}"
        ];
        
        return $urls[$provider] ?? null;
    }
}

// Handle booking redirects
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    header('Content-Type: application/json');
    
    try {
        $input = json_decode(file_get_contents('php://input'), true);
        $handler = new BookingRedirectHandler();
        
        $bookingId = $handler->trackBookingClick(
            $input['plan_id'],
            $input['provider'],
            $input['booking_type']
        );
        
        $redirectUrl = $handler->getBookingUrl($input['provider'], $input['plan_data']);
        
        echo json_encode([
            'success' => true,
            'booking_id' => $bookingId,
            'redirect_url' => $redirectUrl
        ]);
        
    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
}
?>