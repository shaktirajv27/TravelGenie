<?php
require_once 'config.php';

class GeminiAPI {
    private $apiKey;
    private $apiUrl;
    
    public function __construct() {
        $this->apiKey = GEMINI_API_KEY;
        $this->apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent';
    }
    
    public function generateContent($prompt) {
        $data = [
            'contents' => [
                [
                    'parts' => [
                        [
                            'text' => $prompt
                        ]
                    ]
                ]
            ],
            'generationConfig' => [
                'temperature' => 0.7,
                'maxOutputTokens' => 2048,
            ]
        ];
        
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $this->apiUrl . '?key=' . $this->apiKey,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
            ],
            CURLOPT_TIMEOUT => 30,
        ]);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if (curl_error($ch)) {
            curl_close($ch);
            throw new Exception('Curl error: ' . curl_error($ch));
        }
        
        curl_close($ch);
        
        if ($httpCode !== 200) {
            throw new Exception('API request failed with status: ' . $httpCode . ' Response: ' . $response);
        }
        
        $result = json_decode($response, true);
        
        if (!isset($result['candidates'][0]['content']['parts'][0]['text'])) {
            throw new Exception('Invalid API response format');
        }
        
        return $result['candidates'][0]['content']['parts'][0]['text'];
    }
    
    public function createTravelPlan($destination, $duration, $budget, $interests, $travelType) {
        $interestsText = implode(', ', $interests);
        
        $prompt = "Create a detailed {$duration}-day travel plan for {$destination} with the following preferences:
        
        - Budget: {$budget}
        - Travel Type: {$travelType}
        - Interests: {$interestsText}
        
        Please provide:
        1. **Day-by-day itinerary** with specific activities and timing
        2. **Hotel recommendations** (3-4 options) with price ranges and why they're suitable
        3. **Restaurant recommendations** (5-6 options) covering different meal types and cuisines
        4. **Transportation advice** including local transport options
        5. **Hidden gems** and local experiences unique to the destination
        6. **Weather considerations** and best times to visit attractions
        7. **Budget breakdown** for accommodation, food, activities, and transport
        8. **Local tips and cultural insights**
        
        Format the response with clear headings and bullet points. Make it practical and actionable for travelers.";
        
        return $this->generateContent($prompt);
    }
}
?>