import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class UniversityScreen extends StatefulWidget {
  @override
  _UniversityScreenState createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _universities = [];
  List<String> _suggestions = [];

  Future<void> fetchUniversities(String country) async {
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$country');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _universities = data;
      });
    }
  }

  void updateSuggestions(String input) {
    List<String> countries = [
      'Dominican Republic',
      'United States',
      'Canada',
      'Mexico',
      'Spain',
      'Germany',
      'Brazil',
      'Argentina',
      'France',
      'Italy'
    ];
    setState(() {
      _suggestions = countries.where((c) => c.toLowerCase().contains(input.toLowerCase())).toList();
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Universidades por País')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (text) {
                updateSuggestions(text);
              },
              decoration: InputDecoration(labelText: 'País (en inglés)'),
            ),
            if (_suggestions.isNotEmpty)
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        _controller.text = _suggestions[index];
                        _suggestions.clear();
                        fetchUniversities(_controller.text);
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => fetchUniversities(_controller.text),
              child: Text('Buscar Universidades'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  var uni = _universities[index];
                  return ListTile(
                    title: Text(uni['name']),
                    subtitle: Text(uni['domains'].join(', ')),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () {
                      final url = uni['web_pages'][0];
                      _launchUrl(url);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
