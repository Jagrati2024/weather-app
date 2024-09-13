import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile_screen.dart';
import 'weather_screen.dart';
import 'weather_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String apiKey = 'eec37f94b66fc29e290d0765337afbbb';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherProvider(apiKey: apiKey)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(apiKey: apiKey),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String apiKey;

  WelcomePage({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Weather App'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Center(
              child: Row(
                children: [
                  SizedBox(width: 60),
                  Icon(Icons.wb_sunny_outlined, size: 100, color: Colors.orange),
                  Icon(Icons.wb_cloudy, size: 100, color: Colors.lightBlueAccent),

                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Weather App!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              },
              child: Text(('Set Profile'),style:TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WeatherScreen(apiKey: apiKey)),
                );
              },
              child: Text(('Check Weather'),style:TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

