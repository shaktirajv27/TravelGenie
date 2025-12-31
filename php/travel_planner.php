<?php
// Clean output buffer to prevent extra output
ob_start();

require_once 'config.php';
require_once 'database.php';
require_once 'auth.php';
require_once 'gemini_api.php';

class EnhancedTravelPlanner {
    private $db;
    private $auth;
    private $gemini;
    
    public function __construct() {
        $this->db = Database::getInstance();
        $this->auth = new AuthSystem();
        $this->gemini = new GeminiAPI();
    }
    
    public function createTravelPlan($planData) {
        // Validate user session
        $user = $this->auth->getCurrentUser();
        if (!$user) {
            throw new Exception('Please log in to create travel plans');
        }
        
        // Validate required fields
        $required = ['destination', 'duration', 'budget', 'travelType'];
        foreach ($required as $field) {
            if (!isset($planData[$field]) || empty(trim($planData[$field]))) {
                throw new Exception("Please fill in the {$field} field");
            }
        }
        
        // Validate duration
        if (!is_numeric($planData['duration']) || $planData['duration'] < 1 || $planData['duration'] > 30) {
            throw new Exception('Duration must be between 1 and 30 days');
        }
        
        // Generate AI travel plan
        $aiResponse = $this->gemini->createTravelPlan(
            trim($planData['destination']),
            (int)$planData['duration'],
            $planData['budget'],
            $planData['interests'] ?? [],
            $planData['travelType']
        );
        
        // Save to database
        $stmt = $this->db->prepare("
            INSERT INTO travel_plans (user_id, destination, duration, budget_range, travel_type, interests, ai_response, plan_data, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'draft')
        ");
        
        $stmt->execute([
            $user['id'],
            trim($planData['destination']),
            (int)$planData['duration'],
            $planData['budget'],
            $planData['travelType'],
            json_encode($planData['interests'] ?? []),
            $aiResponse,
            json_encode($planData)
        ]);
        
        $planId = $this->db->lastInsertId();
        
        return [
            'plan_id' => $planId,
            'ai_response' => $aiResponse,
            'booking_links' => $this->generateBookingLinks($planData)
        ];
    }
    
    public function getUserTravelPlans($userId) {
        $stmt = $this->db->prepare("
            SELECT id, destination, duration, budget_range, travel_type, status, created_at 
            FROM travel_plans 
            WHERE user_id = ? 
            ORDER BY created_at DESC
        ");
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    }
    
    public function getTravelPlanDetails($planId, $userId) {
        $stmt = $this->db->prepare("
            SELECT * FROM travel_plans 
            WHERE id = ? AND user_id = ?
        ");
        $stmt->execute([$planId, $userId]);
        return $stmt->fetch();
    }
    
    private function generateBookingLinks($planData) {
        $destination = urlencode(trim($planData['destination']));
        $checkIn = date('Y-m-d', strtotime('+7 days'));
        $checkOut = date('Y-m-d', strtotime('+' . (7 + (int)$planData['duration']) . ' days'));
        
        return [
            'booking_com' => "https://www.booking.com/searchresults.html?ss={$destination}&checkin={$checkIn}&checkout={$checkOut}",
            'expedia' => "https://www.expedia.com/Hotel-Search?destination={$destination}&startDate={$checkIn}&endDate={$checkOut}",
            'kayak_flights' => "https://www.kayak.com/flights?depart={$checkIn}&return={$checkOut}",
            'tripadvisor' => "https://www.tripadvisor.com/Search?q={$destination}",
            'airbnb' => "https://www.airbnb.com/s/{$destination}?checkin={$checkIn}&checkout={$checkOut}"
        ];
    }
}

// Clean any previous output
ob_clean();

// Handle requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Set headers
    header('Content-Type: application/json; charset=utf-8');
    
    try {
        // Get input
        $rawInput = file_get_contents('php://input');
        
        if (empty($rawInput)) {
            throw new Exception('No input data received');
        }
        
        $input = json_decode($rawInput, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Invalid JSON format');
        }
        
        if (!is_array($input)) {
            throw new Exception('Invalid input format');
        }
        
        $planner = new EnhancedTravelPlanner();
        $action = isset($input['action']) ? $input['action'] : 'create';
        
        switch ($action) {
            case 'create':
                $result = $planner->createTravelPlan($input);
                echo json_encode(['success' => true, 'data' => $result]);
                break;
                
            case 'get_plans':
                $auth = new AuthSystem();
                $user = $auth->getCurrentUser();
                if (!$user) throw new Exception('Not authenticated');
                
                $plans = $planner->getUserTravelPlans($user['id']);
                echo json_encode(['success' => true, 'data' => $plans]);
                break;
                
            case 'get_plan_details':
                $auth = new AuthSystem();
                $user = $auth->getCurrentUser();
                if (!$user) throw new Exception('Not authenticated');
                
                if (!isset($input['plan_id'])) {
                    throw new Exception('Plan ID is required');
                }
                
                $details = $planner->getTravelPlanDetails($input['plan_id'], $user['id']);
                echo json_encode(['success' => true, 'data' => $details]);
                break;
                
            default:
                throw new Exception('Invalid action');
        }
        
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false, 
            'error' => $e->getMessage()
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Method not allowed'
    ]);
}

// End output buffering
ob_end_flush();
?>