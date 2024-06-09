import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test/constants.dart'; // Importing constants.dart file which contains API link and key
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  // Function to fetch weather data for current location
  Future<String?> getCurrentLocationWeather() async {
    // Getting the current device location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );

    // Constructing the API link with latitude and longitude
    var uri = '${apiLink}lat=${position.latitude}&lon=${position.longitude}&appid=${apiKey}';
    var url = Uri.parse(uri);

    // Continuous loop to fetch weather data until successful
    while (true) {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // If response is successful, decode JSON data and extract temperature
        var data = response.body;
        var decodedData = jsonDecode(data);
        String temp = (decodedData['main']['temp'] - 273).toDouble().toStringAsFixed(2);
        return '${temp}℃'; // Returning temperature in Celsius
      } else {
        // If error fetching weather data, return an error message
        return 'Error fetching weather data';
      }
    }
  }
}
