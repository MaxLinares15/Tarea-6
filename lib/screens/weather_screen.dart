import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? _description;
  double? _temp;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final apiKey = 'a587cdfad6ae081f2004cdb7a8bf9e7b';
    final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?q=Santo%20Domingo,DO&appid=$apiKey&units=metric',
    );


    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _description = data['weather'][0]['description'];
          _temp = data['main']['temp'];
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima en RD')),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _error != null
                ? Text(_error!, style: TextStyle(color: Colors.red))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Santo Domingo',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _description!,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${_temp?.toStringAsFixed(1)}°C',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
      ),
    );
  }
}
