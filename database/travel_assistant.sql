-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 02, 2025 at 04:15 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `travel_assistant`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `travel_plan_id` int(11) DEFAULT NULL,
  `booking_type` enum('hotel','flight','activity','restaurant') DEFAULT NULL,
  `provider` varchar(50) DEFAULT NULL,
  `booking_reference` varchar(100) DEFAULT NULL,
  `booking_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`booking_data`)),
  `amount` decimal(10,2) DEFAULT NULL,
  `currency` varchar(3) DEFAULT 'USD',
  `status` enum('pending','confirmed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `subject` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `newsletter_opt_in` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('new','read','replied') DEFAULT 'new'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `first_name`, `last_name`, `email`, `phone`, `subject`, `message`, `newsletter_opt_in`, `created_at`, `status`) VALUES
(1, 'Mayurdhvajsinh', 'Chudasama', 'shaktirajv44@gmail.com', '09328337072', 'billing', 'hgfdfghjhgfgh', 0, '2025-09-07 08:57:06', 'new');

-- --------------------------------------------------------

--
-- Table structure for table `travel_plans`
--

CREATE TABLE `travel_plans` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `duration` int(11) NOT NULL,
  `budget_range` varchar(20) DEFAULT NULL,
  `travel_type` varchar(20) DEFAULT NULL,
  `interests` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`interests`)),
  `ai_response` longtext DEFAULT NULL,
  `plan_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`plan_data`)),
  `status` enum('draft','confirmed','completed') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `travel_plans`
--

INSERT INTO `travel_plans` (`id`, `user_id`, `destination`, `duration`, `budget_range`, `travel_type`, `interests`, `ai_response`, `plan_data`, `status`, `created_at`, `updated_at`) VALUES
(16, 1, 'Dwarka', 3, 'mid-range', 'friends', '[\"adventure\",\"culture\",\"food\",\"history\"]', '## 3-Day Dwarka Travel Plan for Friends (Mid-Range Budget)\n\n**Theme:** Adventure, Culture, Food, History\n\n**Best time to visit:** October to March (pleasant weather)\n\n**1. Day-by-Day Itinerary:**\n\n**Day 1: Arrival & Coastal Exploration**\n\n* **Morning (9:00 AM):** Arrive at Jamnagar Airport (JGA) or Dwarka Railway Station. Transfer to your hotel in Dwarka.\n* **Afternoon (12:00 PM):** Check in, freshen up, and have lunch at a local restaurant.\n* **Afternoon (2:00 PM):** Visit Dwarkadhish Temple, participate in the afternoon aarti.\n* **Late Afternoon (4:00 PM):** Explore the Gopi Talav and Gomti Ghat.\n* **Evening (6:00 PM):** Enjoy the sunset at Beyt Dwarka (ferry ride required).\n* **Night (8:00 PM):** Dinner at a seafood restaurant.\n\n**Day 2: History & Heritage**\n\n* **Morning (8:00 AM):** Visit the Rukmini Devi Temple and learn about its history.\n* **Late Morning (10:00 AM):** Explore the Sudama Setu, a suspension bridge offering panoramic views.\n* **Afternoon (12:00 PM):** Lunch at a Gujarati Thali restaurant.\n* **Afternoon (2:00 PM):**  Visit the Dwarka Lighthouse and enjoy the coastal scenery.\n* **Late Afternoon (4:00 PM):**  Explore the Nageshwar Jyotirlinga Temple.\n* **Evening (7:00 PM):**  Enjoy street food and local markets.\n* **Night (9:00 PM):** Dinner at your hotel or a local restaurant.\n\n**Day 3: Adventure & Departure**\n\n* **Morning (7:00 AM):**  Visit Dunny Point for birdwatching and nature trails (optional early morning camel ride).\n* **Late Morning (10:00 AM):**  Enjoy water sports activities at Shivrajpur Beach (jet skiing, surfing, etc.).\n* **Afternoon (1:00 PM):**  Have lunch at a beach shack.\n* **Afternoon (3:00 PM):**  Visit the Bhadkeshwar Mahadev Temple, situated on an island.\n* **Evening (5:00 PM):**  Depart from Jamnagar Airport or Dwarka Railway Station.\n\n\n**2. Hotel Recommendations:**\n\n* **Hotel The Grand Dwarika:** (₹3,000-₹5,000) Offers comfortable rooms, sea views, and good amenities.\n* **Hotel Goverdhan Greens:** (₹2,500-₹4,000) Known for its vegetarian restaurant and proximity to the temple.\n* **Hotel Krishna Inn:** (₹1,500-₹3,000) A budget-friendly option with decent facilities.\n* **Shree Krishna Residency:** (₹1,000-₹2,500) Basic but clean accommodation near the temple.\n\n\n**3. Restaurant Recommendations:**\n\n* **Shree Ram Restaurant:** Gujarati Thali\n* **Hotel Milan Restaurant:** Kathiyawadi cuisine\n* **Manek Restaurant:** Seafood\n* **Chakrapani Restaurant:** South Indian\n* **Snack Attack:** Street food and snacks\n* **Cafe Coffee Day:** Coffee and light bites\n\n\n**4. Transportation Advice:**\n\n* **Local Transport:** Auto-rickshaws, taxis, and local buses are readily available.\n* **From Airport/Railway Station:** Pre-booked taxis or auto-rickshaws are recommended.\n* **Beyt Dwarka:** Ferry services are available from Okha port.\n\n\n**5. Hidden Gems & Local Experiences:**\n\n* **Dunny Point:** Explore the serene beaches and birdwatching opportunities.\n* **Shivrajpur Beach:** Enjoy water sports and witness stunning sunsets.\n* **Local Markets:** Explore the vibrant markets for handicrafts and souvenirs.\n* **Interact with locals:** Learn about their culture and traditions.\n* **Attend a local festival:** If your trip coincides with a festival, experience the vibrant celebrations.\n\n\n**6. Weather Considerations:**\n\n* **Summer (April-June):** Hot and humid, avoid visiting during these months.\n* **Monsoon (July-September):** Moderate rainfall, can be enjoyable if you don\'t mind the rain.\n* **Winter (October-March):** Pleasant weather, ideal for sightseeing and outdoor activities.\n\n\n**7. Budget Breakdown (per person for 3 days):**\n\n* **Accommodation:** ₹3,000 - ₹9,000 (based on hotel choice)\n* **Food:** ₹3,000 - ₹4,500\n* **Activities:** ₹2,000 - ₹3,000 (including ferry, water sports, etc.)\n* **Transport:** ₹1,500 - ₹2,500\n\n**Total:** ₹9,500 - ₹19,000 (flexible based on choices)\n\n\n**8. Local Tips & Cultural Insights:**\n\n* **Dress modestly:** Especially when visiting temples.\n* **Bargain respectfully:** While shopping in local markets.\n* **Learn a few basic Gujarati phrases:** It will enhance your interaction with locals.\n* **Be mindful of religious customs:** Photography may be restricted in some areas.\n* **Try the local delicacies:**  Don\'t miss out on the Gujarati Thali and Kathiyawadi cuisine.\n* **Carry cash:**  Smaller establishments may not accept cards.\n* **Stay hydrated:** Drink plenty of water, especially during the warmer months.\n\n\nThis itinerary is a suggestion and can be customized based on your preferences and time constraints.  Enjoy your trip to Dwarka! \n', '{\"destination\":\"Dwarka\",\"duration\":\"3\",\"budget\":\"mid-range\",\"interests\":[\"adventure\",\"culture\",\"food\",\"history\"],\"travelType\":\"friends\"}', 'draft', '2025-07-27 10:58:30', '2025-07-27 10:58:30'),
(17, 1, 'jammu and kashmir', 5, 'mid-range', 'couple', '[\"adventure\",\"food\",\"nature\",\"history\"]', '## 5-Day Jammu & Kashmir Itinerary for Couples (Mid-Range Budget)\n\n**Theme:** Adventure, Food, Nature & History\n\n**Best Time to Visit:** May-June or September-October for pleasant weather.\n\n**1. Day 1: Arrival in Srinagar & Dal Lake Exploration**\n\n* **Morning (8:00 AM):** Arrive at Srinagar Airport (SXR). Transfer to your hotel in Dal Lake area.\n* **Afternoon (12:00 PM):** Check-in, freshen up, and have lunch at a lakeside restaurant.\n* **Afternoon (2:00 PM):** Shikara ride on Dal Lake, visiting the floating gardens, Char Chinar, and Nehru Park.\n* **Evening (6:00 PM):** Enjoy a sunset shikara ride followed by dinner at a restaurant with live Kashmiri music.\n\n**2. Day 2: Mughal Gardens & Shankaracharya Temple**\n\n* **Morning (9:00 AM):** Visit the Mughal Gardens – Nishat Bagh, Shalimar Bagh, and Chashme Shahi.\n* **Afternoon (1:00 PM):** Lunch at a local restaurant near the gardens.\n* **Afternoon (3:00 PM):** Hike or take a taxi to Shankaracharya Temple for panoramic city views.\n* **Evening (6:00 PM):** Explore the local markets in Srinagar for souvenirs and handicrafts. Dinner at a traditional Wazwan restaurant.\n\n**3. Day 3: Gulmarg Gondola Ride & Adventure**\n\n* **Morning (8:00 AM):** Drive to Gulmarg (2 hours).\n* **Morning (10:00 AM):** Experience the Gulmarg Gondola ride (Phase 1 & 2) for stunning views of the Himalayas.\n* **Afternoon (1:00 PM):** Enjoy lunch at a restaurant with mountain views.\n* **Afternoon (2:30 PM):** Engage in adventure activities like skiing (winter), horseback riding, or ATV rides.\n* **Evening (5:00 PM):** Drive back to Srinagar. Dinner at your hotel or a local restaurant.\n\n**4. Day 4: Pahalgam & Betaab Valley**\n\n* **Morning (8:00 AM):** Drive to Pahalgam (2-3 hours).\n* **Morning (11:00 AM):** Explore Betaab Valley and Aru Valley, known for their scenic beauty.  Consider a pony ride.\n* **Afternoon (1:00 PM):** Enjoy a picnic lunch by the Lidder River.\n* **Afternoon (3:00 PM):** Visit Chandanwari, the starting point for the Amarnath Yatra.\n* **Evening (6:00 PM):** Drive back to Srinagar.  Dinner at a restaurant.\n\n**5. Day 5: Departure**\n\n* **Morning (8:00 AM):** Enjoy a final Kashmiri breakfast.\n* **Morning (9:00 AM):** Depending on your flight schedule, visit the Pari Mahal or the Tulip Garden (seasonal) if time permits.\n* **Afternoon (12:00 PM):** Transfer to Srinagar Airport for departure.\n\n\n**Hotel Recommendations (Srinagar):**\n\n* **The Lalit Grand Palace Srinagar (Luxury - INR 8,000-15,000):** Historic palace hotel with stunning views and excellent service.\n* **Vivanta Dal View, Srinagar (Upscale - INR 6,000-12,000):** Modern hotel with Dal Lake views and comfortable amenities.\n* **Hotel Grand Mumtaz Resorts (Mid-range - INR 3,000-6,000):** Comfortable stay with good location and decent facilities.\n* **Houseboats on Dal Lake (Mid-range - INR 2,500-5,000):**  A unique Kashmiri experience, offering beautiful lake views and cozy accommodations.\n\n**Restaurant Recommendations:**\n\n* **Ahdoos (Traditional Kashmiri):** Wazwan, Rogan Josh, Tabak Maaz\n* **Lhasa Restaurant (Tibetan):** Momos, Thukpa, Thenthuk\n* **Stream Restaurant (Multi-cuisine with Lake Views):**  Indian, Chinese, Continental\n* **Krishna Vaishno Dhaba (Vegetarian):**  North Indian, South Indian dishes\n* **Biryani By Kilo (Biryani Specialist):**  Different types of Biryani\n* **Shamyana Restaurant (Mughlai):** Kebabs, curries, biryanis\n\n**Transportation:**\n\n* **Airport Transfers:** Pre-booked taxis or airport shuttles.\n* **Local Transport:** Auto-rickshaws, shared taxis, and local buses are readily available. Consider hiring a car with a driver for day trips. Shikaras on Dal Lake.\n\n**Hidden Gems & Local Experiences:**\n\n* **Pari Mahal:** A terraced garden with panoramic city views.\n* **Badamwari Garden:**  Beautiful almond blossom garden (spring).\n* **Indus River Rafting:**  Adventure experience near Pahalgam.\n* **Craft Demonstrations:** Learn about carpet weaving, wood carving, and papier-mâché.\n* **Cooking Class:** Learn to make traditional Kashmiri dishes.\n\n**Weather Considerations:**\n\n* **Summer (May-August):** Pleasant weather, ideal for sightseeing and outdoor activities.\n* **Autumn (September-October):** Crisp air and beautiful fall foliage.\n* **Winter (November-February):** Snowfall, ideal for skiing and winter sports.\n* **Spring (March-April):** Tulip season, pleasant weather.\n\n**Budget Breakdown (per couple for 5 days):**\n\n* **Accommodation:** INR 15,000 - 30,000 (mid-range)\n* **Food:** INR 10,000 - 15,000\n* **Activities & Entrance Fees:** INR 5,000 - 10,000\n* **Transport:** INR 5,000 - 8,000\n* **Total:** INR 35,000 - 63,000 (approx. USD 420 - 750)\n\n**Local Tips & Cultural Insights:**\n\n* **Bargaining:**  Negotiate prices while shopping in local markets.\n* **Dress modestly:** Especially when visiting religious sites.\n* **Learn a few basic Kashmiri phrases:** It\'s appreciated by locals.\n* **Respect local customs and traditions.**\n* **Try Kahwa:** Traditional Kashmiri green tea.\n* **Be aware of altitude sickness:**  Especially in Gulmarg and Pahalgam.\n\nThis itinerary is a suggestion and can be customized based on your preferences and available time.  Enjoy your romantic trip to Jammu & Kashmir! \n', '{\"destination\":\"jammu and kashmir\",\"duration\":\"5\",\"budget\":\"mid-range\",\"interests\":[\"adventure\",\"food\",\"nature\",\"history\"],\"travelType\":\"couple\"}', 'draft', '2025-07-29 06:46:49', '2025-07-29 06:46:49'),
(18, 1, 'Rajkot', 3, 'budget', 'solo', '[\"culture\",\"nightlife\",\"shopping\"]', '## 3-Day Budget Solo Trip to Rajkot: Culture, Nightlife & Shopping\n\nThis itinerary focuses on exploring Rajkot\'s cultural heritage, experiencing its nightlife, and indulging in some shopping, all while sticking to a budget.\n\n**1. Day-by-day Itinerary**\n\n* **Day 1: Cultural Immersion**\n    * 9:00 AM: Start your day with a visit to the **Watson Museum**, showcasing Rajkot\'s history and art. (Entry Fee: ~₹20)\n    * 11:00 AM: Explore the **Kaba Gandhi No Delo**, Mahatma Gandhi\'s childhood home, offering a glimpse into his early life. (Entry Fee: Nominal)\n    * 1:00 PM: Lunch at **Jalaram Khaman House** for authentic Gujarati snacks. (Budget: ₹150)\n    * 3:00 PM: Visit the **Rotary Dolls Museum**, showcasing dolls from around the world. (Entry Fee: ~₹50)\n    * 5:00 PM: Stroll through the bustling **Gujari Bazaar** for local handicrafts and textiles.\n    * 7:00 PM: Dinner at **Patel Vihar Restaurant** for a traditional Gujarati thali. (Budget: ₹250)\n\n* **Day 2: Nightlife & Entertainment**\n    * 10:00 AM: Visit the **Aji Dam**, a scenic reservoir ideal for a relaxing morning. (Entry Fee: Nominal)\n    * 1:00 PM: Lunch at **Balaji Sandwich** for a quick and tasty bite. (Budget: ₹100)\n    * 3:00 PM: Explore the **Race Course Ground** and enjoy the local atmosphere.\n    * 6:00 PM: Relax and enjoy street food at **Ring Road**.\n    * 8:00 PM: Experience Rajkot\'s nightlife at **The Grand Thakar Hotel**\'s rooftop restaurant or explore local pubs like **The Chocolate Room**. (Budget: ₹500-₹1000)\n\n* **Day 3: Shopping & Departure**\n    * 9:00 AM: Visit the **Crystal Mall** or **Big Bazaar** for modern shopping.\n    * 12:00 PM: Lunch at **Iscon Ganthiya Rath** for authentic Kathiawadi snacks. (Budget: ₹150)\n    * 2:00 PM: Explore the local markets for souvenirs and traditional clothing.\n    * 4:00 PM: Enjoy a final Gujarati snack at **Rasranjan**. (Budget: ₹100)\n    * 6:00 PM: Depart from Rajkot.\n\n\n**2. Hotel Recommendations**\n\n* **Hotel Harmony:** (₹1000-₹2000)  Offers comfortable rooms and a central location. Suitable for budget travelers.\n* **The Imperial Palace:** (₹2000-₹4000) A more upscale option with better amenities, but still within a reasonable price range.\n* **Fortune Park JPS Grand:** (₹3000-₹5000) A business hotel offering comfortable stays and good services. \n* **Hotel Marasa Sarovar Portico:** (₹2500-₹4500) A blend of modern and traditional aesthetics, offering a comfortable stay.\n\n**3. Restaurant Recommendations**\n\n* **Jalaram Khaman House:** Gujarati snacks\n* **Patel Vihar Restaurant:** Traditional Gujarati Thali\n* **Balaji Sandwich:** Sandwiches and street food\n* **Iscon Ganthiya Rath:** Kathiawadi snacks\n* **Rasranjan:** Sweets and snacks\n* **La Pino\'z Pizza:** Pizzas and Italian dishes\n\n**4. Transportation Advice**\n\n* **Auto-rickshaws:** readily available and affordable. Negotiate fares beforehand.\n* **BRTS (Bus Rapid Transit System):** a cost-effective way to travel within the city.\n* **Local buses:** an even cheaper option but can be crowded.\n\n\n**5. Hidden Gems & Local Experiences**\n\n* **Lang Library:** A historical library with a vast collection of books.\n* **Ramnath Mahadev Temple:** A serene temple located on the banks of the Aji River.\n* **Exploring the old city lanes:** Discover hidden temples, local shops, and traditional architecture.\n\n\n**6. Weather Considerations**\n\n* Best time to visit: October to March (pleasant weather).\n* Summers (April-June) are extremely hot.\n* Monsoon (July-September) can be humid.\n\n\n**7. Budget Breakdown (Approximate)**\n\n* Accommodation (3 nights): ₹3000 - ₹6000\n* Food (3 days): ₹1500 - ₹2500\n* Activities & Entry Fees: ₹500\n* Transport: ₹500\n* **Total:** ₹5500 - ₹9500\n\n\n**8. Local Tips & Cultural Insights**\n\n* Learn a few basic Gujarati phrases.\n* Dress modestly, especially when visiting religious sites.\n* Bargaining is common in local markets.\n* Be respectful of local customs and traditions.\n* Gujarati cuisine is predominantly vegetarian.\n* Rajkot is known for its vibrant festivals, especially Navratri.\n\n\nThis itinerary is a suggestion and can be customized to your preferences. Remember to research and book accommodations and transportation in advance, especially during peak season. Enjoy your solo trip to Rajkot! \n', '{\"destination\":\"Rajkot\",\"duration\":\"3\",\"budget\":\"budget\",\"interests\":[\"culture\",\"nightlife\",\"shopping\"],\"travelType\":\"solo\"}', 'draft', '2025-08-11 15:23:53', '2025-08-11 15:23:53'),
(19, 1, 'Dubai', 3, 'mid-range', 'solo', '[\"adventure\",\"food\",\"nightlife\"]', '## 3-Day Dubai Solo Adventure: Mid-Range Budget\n\nThis itinerary balances adventure, food, and nightlife while catering to a mid-range budget.\n\n**1. Day-by-Day Itinerary**\n\n* **Day 1: Desert Safari & Arabian Nights**\n    * Morning (8:00 AM):  Pick-up for a desert safari. Enjoy dune bashing, sandboarding, camel riding.\n    * Afternoon (1:00 PM):  Lunch at a desert camp.\n    * Evening (6:00 PM): Cultural activities at the camp: henna painting, shisha, traditional performances.\n    * Night (9:00 PM): Return to Dubai. Explore the vibrant Barsha Heights area for dinner and drinks.\n\n* **Day 2: City Exploration & High Views**\n    * Morning (9:00 AM): Visit the Jumeirah Mosque.\n    * Late Morning (11:00 AM): Explore the historic Al Fahidi district (Bastakiya) and its art galleries.\n    * Lunch (1:00 PM): Enjoy traditional Emirati food at a local restaurant in Al Fahidi.\n    * Afternoon (3:00 PM):  Visit the Dubai Museum.\n    * Evening (5:00 PM):  Ascend the Burj Khalifa for sunset views.\n    * Night (7:00 PM): Dinner and drinks at a restaurant in Downtown Dubai with Burj Khalifa views.\n\n* **Day 3: Beach Fun & Water Activities**\n    * Morning (9:00 AM):  Head to Kite Beach. Try kitesurfing or paddleboarding.\n    * Lunch (1:00 PM): Casual beachside lunch.\n    * Afternoon (3:00 PM):  Explore La Mer, a beachfront entertainment district with shops and cafes.\n    * Evening (6:00 PM): Enjoy a sunset cruise along Dubai Marina.\n    * Night (8:30 PM): Dinner at a restaurant in Dubai Marina followed by exploring the nightlife in the area.\n\n\n**2. Hotel Recommendations**\n\n* **Rove Downtown (Mid-range):** Stylish, modern hotel close to the Burj Khalifa and Dubai Mall.  (AED 300-500 per night)\n* **Citymax Bur Dubai (Budget-friendly):** Comfortable option in a central location, offering good value. (AED 200-400 per night)\n* **Avani Deira Dubai Hotel (Mid-range):** Located near the Creek, offers a rooftop pool and stylish rooms. (AED 350-550 per night)\n* **Paramount Hotel Midtown (Mid-range to Upscale):** Hollywood-themed hotel with a vibrant atmosphere, close to major attractions. (AED 400-700 per night)\n\n\n**3. Restaurant Recommendations**\n\n* **Bu Qtair (Seafood):** Fresh, affordable seafood cooked to order.\n* **Ravi Restaurant (Pakistani/Indian):** A Dubai institution known for its delicious and cheap curries.\n* **Thiptara (Thai):** Fine-dining Thai restaurant at the Palace Downtown, offering stunning Burj Khalifa views.\n* **Al Ustad Special Kabab (Iranian):** Delicious and affordable kebabs in a casual setting.\n* **Logma (Emirati):** Modern Emirati cuisine in a stylish setting.\n* **Pierchic (Seafood):** Overwater dining experience at the Al Qasr hotel, perfect for a romantic dinner or special occasion.\n\n\n**4. Transportation Advice**\n\n* **Dubai Metro:** Efficient and affordable, connects most major areas.\n* **Buses:** Extensive network, but can be slower than the metro.\n* **Taxis:** Readily available, but can be expensive during peak hours.\n* **Ride-hailing apps (Uber/Careem):** Convenient and generally cheaper than taxis.\n\n\n**5. Hidden Gems & Local Experiences**\n\n* **Alserkal Avenue:** A vibrant arts district with galleries, cafes, and performance spaces.\n* **Coffee Museum:** Learn about the history of coffee and sample different brews.\n* **Camel racing:** A traditional Emirati sport (seasonal).\n* **Abra ride across Dubai Creek:** A cheap and scenic way to experience old Dubai.\n\n\n**6. Weather Considerations**\n\n* **Best time to visit:** October to April (pleasant temperatures).\n* **Summer months (May-September):** Extremely hot and humid, making outdoor activities challenging.\n* **Plan indoor activities during the hottest part of the day.**\n\n\n**7. Budget Breakdown (per day, approximate)**\n\n* **Accommodation:** AED 250-500\n* **Food:** AED 150-300\n* **Activities:** AED 200-500 (depending on the activity)\n* **Transport:** AED 50-100\n\n\n**8. Local Tips & Cultural Insights**\n\n* **Dress modestly:** Especially when visiting religious sites.\n* **Alcohol consumption:** Restricted to licensed venues.\n* **Public displays of affection:** Keep it minimal.\n* **Friday is the holy day:** Many businesses operate on reduced hours.\n* **Bargaining is common in souks (markets).**\n* **Learn a few basic Arabic phrases:** It\'s appreciated by locals.\n\n\nThis itinerary provides a framework. Customize it based on your interests and budget. Enjoy your Dubai adventure! \n', '{\"destination\":\"Dubai\",\"duration\":\"3\",\"budget\":\"mid-range\",\"interests\":[\"adventure\",\"food\",\"nightlife\"],\"travelType\":\"solo\"}', 'draft', '2025-08-29 03:47:07', '2025-08-29 03:47:07'),
(20, 3, 'gandhinagar', 3, 'budget', 'couple', '[\"food\",\"nightlife\"]', '## 3-Day Budget-Friendly Gandhinagar Itinerary for Couples (Food & Nightlife Focus)\n\nThis itinerary focuses on exploring Gandhinagar with a focus on food and some nightlife, while staying within a budget.  Gandhinagar\'s nightlife is relatively limited compared to larger cities, but we\'ll highlight available options.\n\n**1. Day-by-Day Itinerary:**\n\n**Day 1: Cultural Immersion & Street Food Delights**\n\n* **Morning (9:00 AM):** Akshardham Temple visit. Explore the magnificent architecture and enjoy the exhibitions. (Budget: Entry fee + optional exhibitions)\n* **Lunch (1:00 PM):**  Enjoy a traditional Gujarati Thali at Gordhan Thal (budget-friendly).\n* **Afternoon (3:00 PM):** Explore the Indroda Nature Park/Dinosaur and Fossil Park. (Budget: Entry fee)\n* **Evening (6:00 PM):**  Street food exploration near Sector 28 market. Try local snacks like dhoklas, khandvi, and pani puri. (Budget: ₹300-500 for two)\n* **Night (8:00 PM):** Relax and enjoy dinner at a local restaurant like Atithi Dining Hall (Gujarati cuisine). (Budget: ₹500-700 for two)\n\n**Day 2:  Capital City Exploration & Evening Entertainment**\n\n* **Morning (9:00 AM):** Visit the Mahatma Mandir Convention and Exhibition Centre.  Explore the architectural marvel. (Budget: Entry fee if any special exhibitions)\n* **Lunch (1:00 PM):**  Try a quick and tasty meal at a local cafe near the Secretariat complex. (Budget: ₹300-400 for two)\n* **Afternoon (3:00 PM):** Visit the Children\'s Park and enjoy the recreational activities. (Budget: Entry fee)\n* **Evening (6:00 PM):**  Explore the Sector 17 market for shopping and street food.\n* **Night (8:00 PM):**  Dinner and drinks (if available) at a restaurant with a rooftop or outdoor setting.  Check local listings for live music or events.  (Budget: ₹700-1000 for two)\n\n**Day 3:  Serenity & Departure**\n\n* **Morning (9:00 AM):** Visit the Sarita Udyan, a beautiful garden for a peaceful stroll. (Budget: Entry fee, if any)\n* **Brunch (11:00 AM):** Enjoy a leisurely brunch at a cafe like The Grand Bhagwati Coffee Culture. (Budget: ₹500-700 for two)\n* **Afternoon (1:00 PM):** Depending on your departure time, visit the Adalaj Stepwell (slightly outside Gandhinagar but worth a visit) or revisit a favorite spot.  (Budget: Entry fee + transport)\n* **Evening (4:00 PM onwards):**  Depart from Gandhinagar.\n\n\n**2. Hotel Recommendations:**\n\n* **Fortune Inn Haveli:** (₹3000-₹5000) Offers comfortable stays and good dining options. Suitable for a mid-range budget.\n* **Hotel Leela Grande:** (₹2000-₹4000) A good option with modern amenities.\n* **Ginger Gandhinagar:** (₹1500-₹2500) Budget-friendly hotel with basic amenities.\n* **Capital O 19487 Hotel Dev Corporate:** (₹1000-₹2000) A very budget-friendly option suitable for short stays.\n\n\n**3. Restaurant Recommendations:**\n\n* **Gordhan Thal:** Traditional Gujarati Thali\n* **Atithi Dining Hall:** Gujarati and Punjabi cuisine\n* **The Grand Bhagwati Coffee Culture:** Cafe with a variety of options\n* **Swati Snacks:**  Popular for street food-style snacks\n* **Toran Dining Hall:** Another popular option for Gujarati Thali\n* **Iscon Ganthiya Rath:** Local snacks and fast food.\n\n\n**4. Transportation Advice:**\n\n* **Local Buses:**  Affordable and readily available for getting around the city.\n* **Auto-rickshaws:**  Convenient for shorter distances, negotiate fares beforehand.\n* **App-based cabs:** Ola and Uber are available.\n* **Renting a scooter:** A good option for exploring at your own pace.\n\n\n**5. Hidden Gems and Local Experiences:**\n\n* **Adalaj Stepwell:**  A beautiful historical stepwell just outside Gandhinagar.\n* **Indroda Dinosaur and Fossil Park:** A unique park showcasing dinosaur fossils and life-sized models.\n* **Explore local markets:**  Experience the vibrant atmosphere and sample street food.\n\n\n**6. Weather Considerations:**\n\n* **Best time to visit:** October to March (pleasant weather).\n* **Summer (April-June):**  Very hot, avoid outdoor activities during peak hours.\n* **Monsoon (July-September):**  Moderate rainfall, can be humid.\n\n\n**7. Budget Breakdown (per couple for 3 days):**\n\n* **Accommodation:** ₹4500-₹9000 (based on hotel choice)\n* **Food:** ₹3000-₹5000\n* **Activities & Entry Fees:** ₹1000-₹2000\n* **Transport:** ₹1000-₹2000\n* **Total:** ₹9500-₹18000 (flexible based on choices)\n\n\n\n**8. Local Tips and Cultural Insights:**\n\n* Dress modestly when visiting religious sites.\n* Gujarati cuisine is predominantly vegetarian.\n* Learn a few basic Gujarati phrases for better interaction with locals.\n* Bargain respectfully while shopping in local markets.\n* Gandhinagar is a planned city, making it easy to navigate.\n\n\nThis detailed plan should help you enjoy a memorable and budget-friendly trip to Gandhinagar. Remember to adjust the itinerary based on your preferences and available time. Enjoy your trip! \n', '{\"destination\":\"gandhinagar\",\"duration\":\"3\",\"budget\":\"budget\",\"interests\":[\"food\",\"nightlife\"],\"travelType\":\"couple\"}', 'draft', '2025-09-07 08:32:02', '2025-09-07 08:32:02'),
(21, 3, 'swizarland', 7, 'budget', 'couple', '[\"adventure\",\"food\",\"nature\",\"nightlife\",\"shopping\"]', '## 7-Day Budget-Friendly Switzerland Adventure for Couples\n\nThis itinerary balances adventure, nature, food, nightlife, and shopping while remaining budget-conscious. It focuses on Interlaken as a base due to its central location and access to various activities.\n\n**1. Day-by-Day Itinerary:**\n\n* **Day 1: Arrival in Interlaken & Lakeside Stroll**\n    * Arrive at Zurich Airport (ZRH) and take a direct train to Interlaken (2 hours).\n    * Check into your hotel and leave luggage.\n    * Explore Interlaken town center, stroll along the Aare River, and enjoy the views of Lake Thun and Lake Brienz.\n    * Evening: Budget-friendly dinner at a local restaurant.\n\n* **Day 2: Harder Kulm & Höhematte Park**\n    * Morning: Take the funicular to Harder Kulm for panoramic views of the Jungfrau region. Hike down partway for a scenic experience.\n    * Afternoon: Relax and enjoy the views at Höhematte Park, famous for its paragliders.\n    * Evening: Explore Interlaken\'s nightlife scene - consider a bar with live music.\n\n* **Day 3: Adventure Day - Canyon Swing or White Water Rafting**\n    * Morning: Choose your adventure! Canyon Swing or white water rafting in the Lütschine River. Pre-book for better deals.\n    * Afternoon: Relax by the lake or visit the St. Beatus Caves.\n    * Evening: Enjoy a picnic dinner by the lake.\n\n* **Day 4: Day Trip to Lauterbrunnen & Trummelbach Falls**\n    * Morning: Take a train to Lauterbrunnen, the \"Valley of 72 Waterfalls.\"\n    * Hike to Staubbach Falls, one of the highest free-falling waterfalls in Europe.\n    * Visit Trummelbach Falls, a series of glacial waterfalls inside the mountain.\n    * Evening: Return to Interlaken and enjoy a Swiss fondue dinner.\n\n* **Day 5: Lake Brienz Cruise & Giessbach Falls**\n    * Morning: Take a scenic boat trip on Lake Brienz.\n    * Stop at Giessbach See and hike to the impressive Giessbach Falls, cascading down 14 tiers.\n    * Evening: Enjoy dinner at a restaurant with lake views.\n\n* **Day 6: Shopping & Bern Excursion**\n    * Morning: Explore Interlaken\'s shops for souvenirs and Swiss chocolate.\n    * Afternoon: Take a train to Bern, the Swiss capital. Visit the Zytglogge astronomical clock and explore the Old Town, a UNESCO World Heritage Site.\n    * Evening: Return to Interlaken for a final Swiss dinner.\n\n* **Day 7: Departure**\n    * Enjoy a final breakfast with a view.\n    * Take the train back to Zurich Airport for your departure.\n\n\n**2. Hotel Recommendations (Interlaken):**\n\n* **Balmers Herberge:** (Budget-friendly hostel) Dorm beds and private rooms available. Social atmosphere, great for meeting other travelers. (~$30-$80/night)\n* **Hotel Interlaken:** (Mid-range) Comfortable rooms with classic Swiss style. Central location close to the train station. (~$120-$200/night)\n* **Downtown Hostel Interlaken:** (Budget-friendly hostel) Offers a range of dorm and private rooms.  Central location and social events. (~$35-$90/night)\n* **Hotel Krebs:** (Mid-range) Family-run hotel with a cozy atmosphere. Located near the Interlaken West train station. (~$100-$180/night)\n\n\n**3. Restaurant Recommendations:**\n\n* **Goldener Anker:** Traditional Swiss cuisine, fondue, and raclette. (Mid-range)\n* **Restaurant Schuh:** Casual dining with international and Swiss dishes. (Budget-friendly)\n* **Hooters Interlaken:** American-style bar and grill. (Mid-range)\n* **Little India:** Indian cuisine with a variety of vegetarian and non-vegetarian options. (Budget-friendly)\n* **Spiez Castle Restaurant:** Fine dining with stunning lake views. (Splurge)\n* **Restaurant Taverne:** Mediterranean and Swiss dishes. (Mid-range)\n\n\n**4. Transportation Advice:**\n\n* **Swiss Travel Pass:** Consider a Swiss Travel Pass if you plan on extensive train travel. It offers unlimited travel on trains, buses, and boats.\n* **Half Fare Card:** A Half Fare Card provides a 50% discount on most public transport.\n* **Local buses and trains:** Interlaken has a good local bus network connecting different parts of the town and surrounding areas.\n\n\n**5. Hidden Gems & Local Experiences:**\n\n* **Hike to Schynige Platte:** Offers stunning views of the Eiger, Mönch, and Jungfrau.\n* **Visit Lake Bachalpsee:** Reflecting the majestic mountains, a photographer\'s dream.\n* **Explore the Ballenberg Open-Air Museum:** Discover traditional Swiss architecture and crafts.\n\n\n**6. Weather Considerations:**\n\n* **Summer (June-August):** Warm and sunny, ideal for hiking and outdoor activities. Peak season, so expect higher prices and crowds.\n* **Spring/Autumn (April-May/September-October):** Pleasant weather, fewer crowds, and lower prices.\n* **Winter (November-March):** Cold and snowy, perfect for skiing and snowboarding.\n\n\n**7. Budget Breakdown (per person for 7 days):**\n\n* **Accommodation:** $210 - $700 (hostel) / $840 - $1400 (mid-range)\n* **Food:** $350 - $500 (budget-conscious eating)\n* **Activities:** $300 - $500 (depending on chosen activities)\n* **Transport:** $200 - $400 (depending on travel pass choice)\n* **Total:** $1060 - $2100 (excluding flights)\n\n\n**8. Local Tips & Cultural Insights:**\n\n* **Learn basic German phrases:** While English is widely spoken, knowing some German is appreciated.\n* **Be punctual:** Swiss people are known for their punctuality.\n* **Try local specialties:**  Fondue, raclette, rösti, and Swiss chocolate are must-tries.\n* **Respect the environment:** Switzerland is known for its pristine nature. Dispose of your trash properly and follow hiking trail rules.\n* **Tipping:** Service charges are usually included in the bill, but rounding up is customary.\n\n\nThis itinerary is a starting point. Feel free to adjust it based on your preferences and budget.  Pre-booking accommodations and activities, especially during peak season, is highly recommended. Enjoy your Swiss adventure!\n', '{\"destination\":\"swizarland\",\"duration\":\"7\",\"budget\":\"budget\",\"interests\":[\"adventure\",\"food\",\"nature\",\"nightlife\",\"shopping\"],\"travelType\":\"couple\"}', 'draft', '2025-09-07 10:44:13', '2025-09-07 10:44:13'),
(22, 3, 'Banaras', 5, 'budget', 'friends', '[\"culture\",\"food\",\"nature\",\"history\"]', '## 5-Day Budget-Friendly Banaras Trip for Friends: Culture, Food, Nature & History\n\n**Best Time to Visit:** October to March (pleasant weather). Avoid peak summer (April-June).\n\n**Weather Considerations:** Pack light cotton clothes for most of the year.  Carry a light jacket/shawl for evenings during winter.\n\n**1. Day-by-Day Itinerary:**\n\n* **Day 1: Arrival & Ghats Exploration**\n    * Morning: Arrive at Varanasi Airport/Railway Station. Check into your hotel near the ghats.\n    * Afternoon: Explore the ghats on foot – Dashashwamedh Ghat, Manikarnika Ghat (respectfully observe from a distance), Assi Ghat.\n    * Evening: Witness the Ganga Aarti ceremony at Dashashwamedh Ghat (around 7 PM). Enjoy street food.\n\n* **Day 2: Boat Ride & Sarnath Excursion**\n    * Morning: Sunrise boat ride on the Ganges (around 6 AM). Witness the morning rituals.\n    * Afternoon: Visit Sarnath, the place where Buddha delivered his first sermon. Explore the Dhamek Stupa, Sarnath Museum, and deer park.\n    * Evening: Explore the local markets near Godowlia for souvenirs and textiles.\n\n* **Day 3: Culture & History Deep Dive**\n    * Morning: Visit Ramnagar Fort, a historical fort across the river.\n    * Afternoon: Explore the narrow lanes and discover hidden temples like the Nepali Temple and the Tibetan Temple.\n    * Evening: Attend a classical music or dance performance (check local listings).\n\n* **Day 4: Nature & Relaxation**\n    * Morning: Visit the Chunar Fort, a medieval fortress located about 40 km from Varanasi.\n    * Afternoon: Relax by the ghats, read a book, or enjoy the atmosphere.\n    * Evening: Enjoy a final Ganga Aarti experience, perhaps from a different vantage point.\n\n* **Day 5: Departure**\n    * Morning:  Visit the Kashi Vishwanath Temple (be prepared for queues). Enjoy a final Banarasi breakfast.\n    * Depart from Varanasi Airport/Railway Station.\n\n**2. Hotel Recommendations (Budget):**\n\n* **Zostel Varanasi:** (₹500-₹800/night) Backpacker hostel with a social atmosphere.\n* **BunkedUp Hostels Varanasi:** (₹400-₹700/night) Another hostel option with dorm rooms and private rooms.\n* **Hotel Alka:** (₹800-₹1500/night) Basic but clean hotel near the ghats.\n* **Shiva Lodge:** (₹1000-₹2000/night) Slightly more upscale option with river views.\n\n**3. Restaurant Recommendations:**\n\n* **Kashi Chat Bhandar:** Street food, especially chaat.\n* **Blue Lassi Shop:** Wide variety of lassi flavors.\n* **Dolphin Restaurant:** Rooftop dining with views of the ghats.\n* **Tadka: The Flavours of India:** North Indian cuisine.\n* **Brown Bread Bakery:** Bakery items and breakfast.\n* **Deena Chat Bhandar:** Another popular chaat option.\n\n\n**4. Transportation Advice:**\n\n* **Local Transport:** Auto-rickshaws, cycle rickshaws, and shared tempos are readily available. Negotiate fares beforehand.\n* **Boat Rides:** Hire boats directly from the ghats.  Negotiate prices before embarking.\n* **Sarnath:** Auto-rickshaws or taxis are the best options.\n\n**5. Hidden Gems & Local Experiences:**\n\n* **Walking tour of the old city:** Explore the narrow lanes and discover hidden temples and shrines.\n* **Attend a morning yoga class on the ghats:** Several yoga centers offer classes.\n* **Learn about silk weaving:** Visit a silk weaving workshop.\n* **Take a cooking class and learn to make Banarasi dishes.**\n* **Visit the Bharat Kala Bhavan Museum:** Explore the collection of Indian miniature paintings, sculptures, and textiles.\n\n**6. Budget Breakdown (per person for 5 days):**\n\n* **Accommodation:** ₹2500 - ₹5000 (based on hotel choice)\n* **Food:** ₹2500 - ₹3500 (including street food and restaurant meals)\n* **Activities & Entrance Fees:** ₹1000 - ₹1500\n* **Transport:** ₹1000 - ₹1500\n* **Total:** ₹7000 - ₹11500 (flexible based on choices)\n\n**7. Local Tips & Cultural Insights:**\n\n* Dress respectfully when visiting temples and ghats.\n* Be mindful of the religious customs and traditions.\n* Avoid taking photographs of cremation ceremonies at Manikarnika Ghat.\n* Learn a few basic Hindi phrases – it will enhance your experience.\n* Be prepared for crowds, especially during festivals.\n* Bargain respectfully while shopping.\n* Be cautious of touts and scams.\n* Stay hydrated, especially during warmer months.\n* Carry hand sanitizer and wet wipes.\n\nThis detailed plan offers a framework for your Banaras trip. Remember to be flexible and embrace the unexpected – it\'s part of the charm of this ancient city. Enjoy your journey!\n', '{\"destination\":\"Banaras\",\"duration\":\"5\",\"budget\":\"budget\",\"interests\":[\"culture\",\"food\",\"nature\",\"history\"],\"travelType\":\"friends\"}', 'draft', '2025-09-10 03:49:44', '2025-09-10 03:49:44');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `preferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`preferences`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `nationality` varchar(100) DEFAULT NULL,
  `passport_number` varchar(50) DEFAULT NULL,
  `passport_expiry` date DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `emergency_contact_relationship` varchar(50) DEFAULT NULL,
  `preferred_language` varchar(50) DEFAULT 'English',
  `timezone` varchar(100) DEFAULT 'UTC',
  `currency` varchar(10) DEFAULT 'USD',
  `dietary_restrictions` text DEFAULT NULL,
  `medical_conditions` text DEFAULT NULL,
  `accessibility_needs` text DEFAULT NULL,
  `travel_experience` enum('Beginner','Intermediate','Advanced','Expert') DEFAULT 'Intermediate',
  `preferred_accommodation_type` enum('Hotel','Hostel','Apartment','Resort','Boutique') DEFAULT 'Hotel',
  `budget_range` enum('Budget','Mid-range','Luxury') DEFAULT 'Mid-range',
  `travel_frequency` enum('Rarely','Once a year','2-3 times a year','Monthly','Weekly') DEFAULT 'Once a year',
  `preferred_activities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`preferred_activities`)),
  `occupation` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `linkedin_profile` varchar(255) DEFAULT NULL,
  `instagram_handle` varchar(100) DEFAULT NULL,
  `twitter_handle` varchar(100) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `state_province` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `notification_preferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notification_preferences`)),
  `privacy_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`privacy_settings`)),
  `account_status` enum('Active','Inactive','Suspended') DEFAULT 'Active',
  `email_verified` tinyint(1) DEFAULT 0,
  `phone_verified` tinyint(1) DEFAULT 0,
  `two_factor_enabled` tinyint(1) DEFAULT 0,
  `profile_completion_percentage` int(11) DEFAULT 0,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `profile_visibility` enum('Public','Private','Friends Only') DEFAULT 'Public',
  `failed_login_attempts` int(11) DEFAULT 0,
  `locked_until` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `first_name`, `last_name`, `phone`, `preferences`, `created_at`, `updated_at`, `nationality`, `passport_number`, `passport_expiry`, `emergency_contact_name`, `emergency_contact_phone`, `emergency_contact_relationship`, `preferred_language`, `timezone`, `currency`, `dietary_restrictions`, `medical_conditions`, `accessibility_needs`, `travel_experience`, `preferred_accommodation_type`, `budget_range`, `travel_frequency`, `preferred_activities`, `occupation`, `company`, `linkedin_profile`, `instagram_handle`, `twitter_handle`, `address_line1`, `address_line2`, `state_province`, `postal_code`, `notification_preferences`, `privacy_settings`, `account_status`, `email_verified`, `phone_verified`, `two_factor_enabled`, `profile_completion_percentage`, `last_login_at`, `profile_visibility`, `failed_login_attempts`, `locked_until`) VALUES
(1, 'shaktirajv27', 'shaktirajv44@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$LllQOTE2YjF1UFR2Li9ZZg$3pXRrocx50deuPXF/V3e3J57NkhgOcEuy/XRR9knRLw', 'Shaktiraj', 'Vala', '8160017406', NULL, '2025-07-27 09:46:24', '2025-08-13 13:56:48', '', NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"email_marketing\":false,\"email_trip_updates\":false,\"email_security_alerts\":false,\"sms_trip_reminders\":false,\"push_notifications\":false}', '{\"show_email\":false,\"show_phone\":false,\"show_travel_history\":false,\"allow_friend_requests\":false}', 'Active', 0, 0, 0, 63, NULL, 'Public', 0, NULL),
(3, 'shaktirajv2798', 'shaktirajv27@gmail.com', '$2y$10$YflBL8vmaX45Jf5HZvm.aeI.I7IpAxw/2ViNDebn1ZjsI8ichEo8q', 'Mayurdhvajsinh', 'Chudasama', '09328337072', NULL, '2025-09-07 06:44:07', '2025-09-07 06:44:07', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(4, 'user1', 'user1@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'John', 'Doe', '9000000001', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(5, 'user2', 'user2@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Jane', 'Smith', '9000000002', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(6, 'user3', 'user3@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Alex', 'Brown', '9000000003', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(7, 'user4', 'user4@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Emily', 'Johnson', '9000000004', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(8, 'user5', 'user5@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Michael', 'Lee', '9000000005', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(9, 'user6', 'user6@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Sophia', 'Taylor', '9000000006', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(10, 'user7', 'user7@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Chris', 'Davis', '9000000007', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(11, 'user8', 'user8@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Olivia', 'Wilson', '9000000008', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(12, 'user9', 'user9@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Daniel', 'Clark', '9000000009', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL),
(13, 'user10', 'user10@example.com', '$2y$10$ZC65XDPGSCn0jv3vFVxgMeQ1eDbpCSrIrMZehrDPCXITGmDdHe.YW', 'Emma', 'Martinez', '9000000010', NULL, '2025-09-10 05:26:59', '2025-09-10 05:26:59', NULL, NULL, NULL, NULL, NULL, NULL, 'English', 'UTC', 'USD', NULL, NULL, NULL, 'Intermediate', 'Hotel', 'Mid-range', 'Once a year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', 0, 0, 0, 0, NULL, 'Public', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_feedback`
--

CREATE TABLE `user_feedback` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `feedback_text` text NOT NULL,
  `travel_destination` varchar(100) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_feedback`
--

INSERT INTO `user_feedback` (`id`, `user_id`, `name`, `email`, `rating`, `feedback_text`, `travel_destination`, `profile_image`, `is_approved`, `created_at`) VALUES
(8, NULL, 'Mayur', 'shaktirajv44@gmail.com', 4, 'Best App To Travel Planing', 'Gujarat', 'https://ui-avatars.com/api/?name=Mayur&size=150&background=667eea&color=ffffff', 1, '2025-09-07 08:35:49'),
(9, NULL, 'hiren', 'hiren@gmail.com', 3, 'Where best in look', 'Haven', 'https://ui-avatars.com/api/?name=hiren&size=150&background=667eea&color=ffffff', 1, '2025-09-10 03:46:58');

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_sessions`
--

INSERT INTO `user_sessions` (`id`, `user_id`, `session_token`, `expires_at`, `created_at`) VALUES
(1, 1, 'd94ffbe363964f27bae5a41c00de4fbacefeb1990021b68effe21a3b5382f70b', '2025-07-28 06:16:46', '2025-07-27 09:46:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `travel_plan_id` (`travel_plan_id`),
  ADD KEY `idx_bookings_user_id` (`user_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `travel_plans`
--
ALTER TABLE `travel_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_travel_plans_user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `user_feedback`
--
ALTER TABLE `user_feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_feedback_rating` (`rating`),
  ADD KEY `idx_feedback_approved` (`is_approved`),
  ADD KEY `idx_feedback_created` (`created_at`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token` (`session_token`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_sessions_token` (`session_token`),
  ADD KEY `idx_sessions_expires` (`expires_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `travel_plans`
--
ALTER TABLE `travel_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_feedback`
--
ALTER TABLE `user_feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `user_sessions`
--
ALTER TABLE `user_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`travel_plan_id`) REFERENCES `travel_plans` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `travel_plans`
--
ALTER TABLE `travel_plans`
  ADD CONSTRAINT `travel_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_feedback`
--
ALTER TABLE `user_feedback`
  ADD CONSTRAINT `user_feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
