import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_model.dart';

class GetWeatherApi {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  GetWeatherApi(this.apiKey);

  Future<WeatherModel> getWeatherApi(String cityName) async {
    var url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);


    if (response.statusCode == 200) {
      return WeatherModel.fromJson(responseBody);
    } else {
      throw Exception("Failed to load weather :(");
    }
  }
}
