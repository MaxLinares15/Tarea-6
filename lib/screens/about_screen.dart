import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final String nombre = 'Max Anderson Linares Jaquez';
  final String email = 'dev@correo.com';
  final String githubUrl = 'https://github.com/MaxLinares15';

  final List<String> herramientas = [
    'HTML, CSS, JavaScript',
    'Flutter & Dart',
    'C# y Python',
    'Firebase, MySQL',
    'PHP, Laravel',
    'Git & GitHub',
  ];

  void _launchURL() async {
    final uri = Uri.parse(githubUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $githubUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de mí')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/perfil.jpg'),
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              nombre,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text('Desarrollador Flutter y Web', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: $email'),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lenguajes y herramientas que manejo:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ...herramientas.map((item) => Row(
                          children: [
                            Icon(Icons.check, size: 18, color: Colors.green),
                            SizedBox(width: 6),
                            Text(item),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _launchURL,
              icon: Icon(Icons.link),
              label: Text('Ver mi GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
