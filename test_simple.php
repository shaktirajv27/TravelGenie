<?php
require_once 'php/gemini_api.php';

echo "<h2>Testing Gemini API</h2>";

try {
    $gemini = new GeminiAPI();
    $response = $gemini->generateContent("Hello, please respond with 'API is working!'");
    echo "<p style='color: green;'>✅ Success: " . htmlspecialchars($response) . "</p>";
    
    // Test travel plan
    $plan = $gemini->createTravelPlan("Paris, France", 3, "mid-range", ["culture"], "couple");
    echo "<h3>Travel Plan Test:</h3>";
    echo "<div style='background: #f5f5f5; padding: 15px; max-height: 300px; overflow-y: auto;'>";
    echo nl2br(htmlspecialchars(substr($plan, 0, 500))) . "...";
    echo "</div>";
    
} catch (Exception $e) {
    echo "<p style='color: red;'>❌ Error: " . htmlspecialchars($e->getMessage()) . "</p>";
}
?>