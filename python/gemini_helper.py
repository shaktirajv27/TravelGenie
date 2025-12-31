import google.generativeai as genai
import json
import sys
from datetime import datetime

class GeminiTravelHelper:
    def __init__(self, api_key):
        self.api_key = api_key
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-1.5-pro')
    
    def get_weather_insights(self, destination, duration):
        """Get weather-based travel insights"""
        prompt = f"""
        Provide current weather insights and seasonal recommendations for {destination} 
        for a {duration}-day trip. Include:
        1. Current weather conditions and forecast
        2. Best activities based on weather
        3. Packing recommendations
        4. Seasonal considerations
        5. Weather-related travel tips
        Keep it concise and practical.
        """
        
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Weather insights unavailable: {str(e)}"
    
    def get_local_insights(self, destination, interests):
        """Get local cultural insights and hidden gems"""
        interests_str = ", ".join(interests) if interests else "general travel"
        
        prompt = f"""
        As a local expert for {destination}, provide insider insights for travelers interested in {interests_str}:
        1. Hidden gems only locals know about
        2. Cultural etiquette and local customs
        3. Local phrases that would be helpful
        4. Off-the-beaten-path experiences
        5. Local events or festivals happening soon
        6. Money-saving tips locals use
        7. Best local markets and shopping areas
        8. Authentic local food experiences
        
        Make it authentic and specific to {destination}.
        """
        
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Local insights unavailable: {str(e)}"
    
    def optimize_itinerary(self, destination, itinerary_data):
        """Optimize travel itinerary for efficiency"""
        prompt = f"""
        Optimize this travel itinerary for {destination} to minimize travel time and maximize experiences:
        
        {itinerary_data}
        
        Provide:
        1. Optimized daily schedules with efficient routing
        2. Time-saving tips between locations
        3. Alternative options if places are closed
        4. Best transportation methods for each route
        5. Timing recommendations for attractions
        6. Buffer time suggestions for unexpected delays
        """
        
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Itinerary optimization unavailable: {str(e)}"
    
    def create_travel_plan(self, destination, duration, budget, interests, travel_type):
        """Create a comprehensive travel plan"""
        interests_str = ", ".join(interests) if interests else "general travel"
        
        prompt = f"""
        Create a detailed {duration}-day travel plan for {destination} with the following preferences:
        
        - Budget: {budget}
        - Travel Type: {travel_type}
        - Interests: {interests_str}
        
        Please provide:
        1. **Day-by-day itinerary** with specific activities and timing
        2. **Hotel recommendations** (3-4 options) with price ranges
        3. **Restaurant recommendations** (5-6 options) covering different meal types
        4. **Transportation advice** including local transport options
        5. **Hidden gems** and local experiences unique to the destination
        6. **Weather considerations** and best times to visit attractions
        7. **Budget breakdown** for accommodation, food, activities, and transport
        8. **Local tips and cultural insights**
        
        Format the response with clear headings and bullet points. Make it practical and actionable.
        """
        
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Travel plan generation failed: {str(e)}"

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No command provided"}))
        return
    
    api_key = "AIzaSyCYjcOS21SPnbMXNXy9CjMkQLU84tYu-A4"
    helper = GeminiTravelHelper(api_key)
    
    command = sys.argv[1]
    
    try:
        if command == "weather":
            destination = sys.argv[2] if len(sys.argv) > 2 else ""
            duration = sys.argv[3] if len(sys.argv) > 3 else "7"
            result = helper.get_weather_insights(destination, duration)
            
        elif command == "local":
            destination = sys.argv[2] if len(sys.argv) > 2 else ""
            interests = sys.argv[3].split(",") if len(sys.argv) > 3 else []
            result = helper.get_local_insights(destination, interests)
            
        elif command == "optimize":
            destination = sys.argv[2] if len(sys.argv) > 2 else ""
            itinerary = sys.argv[3] if len(sys.argv) > 3 else ""
            result = helper.optimize_itinerary(destination, itinerary)
            
        elif command == "plan":
            destination = sys.argv[2] if len(sys.argv) > 2 else ""
            duration = sys.argv[3] if len(sys.argv) > 3 else "7"
            budget = sys.argv[4] if len(sys.argv) > 4 else "mid-range"
            interests = sys.argv[5].split(",") if len(sys.argv) > 5 else []
            travel_type = sys.argv[6] if len(sys.argv) > 6 else "solo"
            result = helper.create_travel_plan(destination, duration, budget, interests, travel_type)
            
        else:
            result = "Unknown command. Available commands: weather, local, optimize, plan"
        
        print(json.dumps({
            "success": True,
            "data": result,
            "timestamp": datetime.now().isoformat()
        }))
        
    except Exception as e:
        print(json.dumps({
            "success": False,
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }))

if __name__ == "__main__":
    main()
