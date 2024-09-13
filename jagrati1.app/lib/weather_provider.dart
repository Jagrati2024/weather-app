import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherProvider with ChangeNotifier {
  final String apiKey;

  WeatherProvider({required this.apiKey});

  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _forecast = [];

  Map<String, dynamic> get currentWeather => _currentWeather;
  List<dynamic> get forecast => _forecast;

  Future<void> fetchWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      _currentWeather = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<void> fetchForecast(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      _forecast = json.decode(response.body)['list'];
      notifyListeners();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
