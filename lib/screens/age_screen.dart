import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgeScreen extends StatefulWidget {
  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController _controller = TextEditingController();
  int? _age;
  String? _status;
  String? _imageAsset;
  String? _error;

  Future<void> predictAge(String name) async {
    if (name.trim().isEmpty) {
      setState(() {
        _error = 'Por favor ingresa un nombre válido';
        _age = null;
        _status = null;
        _imageAsset = null;
      });
      return;
    }

    final url = Uri.parse('https://api.agify.io/?name=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int age = data['age'] ?? 0;
        String status;
        String image;

        if (age < 18) {
          status = 'Joven';
          image = 'assets/niño.png';
        } else if (age < 60) {
          status = 'Adulto';
          image = 'assets/adulto.png';
        } else {
          status = 'Anciano';
          image = 'assets/anciano.png';
        }

        setState(() {
          _error = null;
          _age = age;
          _status = status;
          _imageAsset = image;
        });
      } else {
        setState(() {
          _error = 'Error al obtener la edad. Intenta nuevamente.';
          _age = null;
          _status = null;
          _imageAsset = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ocurrió un error: $e';
        _age = null;
        _status = null;
        _imageAsset = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estimación de Edad')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => predictAge(_controller.text),
              child: Text('Estimar Edad'),
            ),
            SizedBox(height: 20),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red),
              ),
            if (_age != null && _status != null && _imageAsset != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(_imageAsset!, height: 120),
                      SizedBox(height: 10),
                      Text(
                        'Edad estimada: $_age años',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Estado: $_status',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
