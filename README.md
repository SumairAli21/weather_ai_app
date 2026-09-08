# 🌤️ AI Weather App (Powered by Gemini)

A smart, beautifully designed weather application built with Flutter that not only shows real-time weather data but also provides intelligent, contextual wardrobe and activity tips using Google's Gemini AI.

## 🚀 Features
* **Real-time Weather Data:** Fetches accurate current weather and temperatures via OpenWeather API.
* **Gemini AI Integration:** Generates clever, context-aware advice based on current weather conditions (e.g., "Grab an umbrella!" or "Perfect weather for a run!").
* **Rich UI/UX:** 
  * Glassmorphism UI components.
  * Real-time typing animation for AI responses (`animated_text_kit`).
  * Smooth loading states (`flutter_spinkit`).
* **Robust Error Handling:** Graceful fallbacks for network timeouts and invalid city names.

## 🛠️ Tech Stack
* **Framework:** Flutter / Dart
* **APIs:** Google Generative AI (Gemini 1.5 Flash), OpenWeatherMap
* **Packages:** `google_generative_ai`, `flutter_dotenv`, `http`, `animated_text_kit`, `flutter_spinkit`

## 📸 Demo
<!-- Yahan apna GIF link daalna mat bhoolna -->
![App Demo](link_to_your_gif_here)

## ⚙️ How to Run Locally
1. Clone the repository.
2. Run `flutter pub get`.
3. Create a `.env` file in the root directory and add your API keys:
   ```env
   GEMINI_API_KEY=your_gemini_key
   WEATHER_API_KEY=your_openweather_key
