import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenderScreen extends StatefulWidget {
  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _gender;

  Future<void> predictGender(String name) async {
    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predicción de Género')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => predictGender(_controller.text),
              child: Text('Predecir Género'),
            ),
            SizedBox(height: 20),
            if (_gender != null)
              Container(
                height: 100,
                color: _gender == 'male' ? Colors.blue : Colors.pink,
                child: Center(
                  child: Text(
                    'Género: $_gender',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}