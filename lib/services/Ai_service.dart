import 'package:weatherapp/models/weather_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';

class AiService {
  final String apiKey;

  AiService(this.apiKey);

  Future<String> getweatherinsights(WeatherModel weather) async {
    final model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: apiKey,
    );

    final prompt = '''
      You are a smart, friendly, and witty weather assistant. 
      The user is currently in ${weather.cityName}.
      The current temperature is ${weather.temperature}°C with ${weather.mainCondition} weather.
      
      Provide a short, engaging 2-sentence tip on what they should wear or do today based on this weather.
      Keep it practical but fun. Do not repeat the exact temperature or city name, just give the tip!
    ''';

    try {
      final response = await model.generateContent(
          [Content.text(prompt)]).timeout(Duration(seconds: 45));

      return response.text?.trim() ??
          "Enjoy your day regardless of the weather!";
    } on TimeoutException {
      return "this take too much time there might be a problem with your internet connection";
    } catch (e) {
      print("========== GEMINI ERROR ==========");
      print(e.toString());
      print("==================================");
      return "Oops! AI is currently taking a nap. Stay safe out there!";
    }
  }
}
