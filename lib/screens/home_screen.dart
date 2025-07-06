import 'package:flutter/material.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'university_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'wordpress_news_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tools = [
      {'title': 'Predicción de Género', 'screen': GenderScreen()},
      {'title': 'Estimación de Edad', 'screen': AgeScreen()},
      {'title': 'Universidades por País', 'screen': UniversityScreen()},
      {'title': 'Clima en RD', 'screen': WeatherScreen()},
      {'title': 'Pokémon Info', 'screen': PokemonScreen()},
      {'title': 'Noticias WordPress', 'screen': WordPressNewsScreen()},
      {'title': 'Acerca de', 'screen': AboutScreen()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Aplicación MultiTool')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/toolbox.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tools.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tools[index]['title']),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => tools[index]['screen'],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
