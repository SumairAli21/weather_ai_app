import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/Ai_service.dart';
import 'package:weatherapp/widgets/weather_api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityCont = TextEditingController();
  WeatherModel? weatherData;

  bool isLoading = false;
  bool isAiLoading = false;
  String? aiInsights;

  late GetWeatherApi weatherApi;
  late AiService aiService;

  @override
  void initState() {
    super.initState();
    // Dotenv se Weather API key pull ki ja rahi hai
    final weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
    weatherApi = GetWeatherApi(weatherApiKey);
    aiService = AiService(dotenv.env['GEMINI_API_KEY'] ?? '');
  }

  @override
  void dispose() {
    cityCont.dispose();
    super.dispose();
  }

  Future<void> fetchWeather() async {
    String cityName = cityCont.text.trim();
    if (cityName.isEmpty) return;
    cityCont.clear();

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      aiInsights = null;
    });

    try {
      WeatherModel weather = await weatherApi
          .getWeatherApi(cityName)
          .timeout(const Duration(seconds: 45));

      if (!mounted) return;

      setState(() {
        weatherData = weather;
        isLoading = false;
        isAiLoading = true;
      });

      // AI Service call
      String insights = await aiService.getweatherinsights(weather);

      if (!mounted) return;

      setState(() {
        aiInsights = insights;
        isAiLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isAiLoading = false;
      });

      String errorMessage = 'City not found ya weather data load nahi hua :(';
      if (error is TimeoutException) {
        errorMessage = 'Connection timeout! Apna internet check karein.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String getWeatherImage(String? mainCondition) {
    if (mainCondition == null) return 'assets/images/default.jpg';

    switch (mainCondition.toLowerCase()) {
      case 'mist':
      case 'fog':
        return 'assets/images/foggy.jpg';
      case 'smoke':
        return 'assets/images/smoke.jpg';
      case 'haze':
        return 'assets/images/haze.jpg';
      case 'clouds':
        return 'assets/images/cloudy.jpg';
      case 'drizzle':
        return 'assets/images/drizz.jpg';
      case 'rain':
      case 'shower rain':
        return 'assets/images/rain.jpg';
      case 'snow':
        return 'assets/images/snow.jpg';
      case 'clear':
        return 'assets/images/sunny.jpg';
      case 'thunderstorm':
        return 'assets/images/thunder.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (weatherData != null)
              Positioned.fill(
                child: Image.asset(
                  getWeatherImage(weatherData!.mainCondition),
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityCont,
                          decoration: InputDecoration(
                            hintText: "Enter (City, State, or Country)",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white70,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox.square(
                        dimension: 50,
                        child: FloatingActionButton(
                          onPressed: fetchWeather,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : weatherData != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                size: 28, color: Colors.white),
                            Text(
                              weatherData!.cityName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              weatherData!.mainCondition,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${weatherData!.temperature.toString()} °C",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 30),
                            if (isAiLoading)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        color: Colors.amber, size: 24),
                                    SizedBox(width: 15),
                                    SpinKitThreeBounce(
                                      color: Colors.white70,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              )
                            else if (aiInsights != null)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.auto_awesome,
                                        color: Colors.amber, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        displayFullTextOnTap: true,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            aiInsights!,
                                            speed: const Duration(
                                                milliseconds: 40),
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      : const Text(
                          "Enter a State/city or country to get the weather",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}