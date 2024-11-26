import 'package:flutter/material.dart';
import 'package:weatherapp/service/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('ad445e38b51c4d2e136ee3990e0278e7');
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  // Fetch weather
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the current city
      String cityName = await _weatherService.getCurrentCity();

      // Get weather for city
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load weather data. Please try again.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading spinner
            : _errorMessage != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Retry'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(
              _weather?.cityName ?? "Unknown City",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Temperature
            Text(
              _weather != null
                  ? "${_weather!.temperature.round()}°C"
                  : "N/A",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
