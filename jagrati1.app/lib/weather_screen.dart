import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'detail_weather_screen.dart';

class WeatherScreen extends StatefulWidget {
  final String apiKey;

  WeatherScreen({required this.apiKey});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _cityName = "";
  String _temperature = "";
  String _description = "";
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    if (location != null && location.isNotEmpty) {
      _cityName = location;
      _fetchBasicWeather(_cityName);
    } else {
      setState(() {
        _cityName = "Default City";
      });
    }
  }

  Future<void> _fetchBasicWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${widget.apiKey}&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      setState(() {
        _cityName = weatherData['name'];
        _temperature = weatherData['main']['temp'].toString();
        _description = weatherData['weather'][0]['description'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather data'),
      ));
    }
  }

  Future<void> _fetchWeather(String city) async {
    try {
      await Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city);
      await Provider.of<WeatherProvider>(context, listen: false).fetchForecast(city);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailWeatherScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather data'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Weather in $_cityName',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_temperature°C',
              style: TextStyle(fontSize: 48),
            ),
            Text(
              _description,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchBasicWeather(_cityController.text);
              },
              child: Text('Search Basic Weather'),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchWeather(_cityController.text);
              },
              child: Text('Show Detailed Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
