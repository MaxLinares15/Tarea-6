import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _pokemon;
  String? _cryUrl;
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'pokemon_player');
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> fetchPokemon(String name) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cry = 'https://play.pokemonshowdown.com/audio/cries/${name.toLowerCase()}.mp3';

      setState(() {
        _pokemon = data;
        _cryUrl = cry;
      });

      await _playCry();
    } else {
      setState(() {
        _pokemon = null;
        _cryUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pokémon no encontrado')),
      );
    }
  }

  Future<void> _playCry() async {
    if (_cryUrl == null || _cryUrl!.isEmpty) return;

    try {
      final uri = Uri.parse(_cryUrl!);
      final response = await http.head(uri);

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El grito no está disponible para este Pokémon.')),
        );
        return;
      }

      await _audioPlayer.stop();

      // Platform check
      if (kIsWeb) {
        // Use low-latency mode for Web
        await _audioPlayer.play(UrlSource(_cryUrl!), volume: 1.0);
      } else {
        await _audioPlayer.play(UrlSource(_cryUrl!), volume: 1.0);
      }
    } catch (e, stack) {
      print('Error reproduciendo sonido: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reproducir el grito del Pokémon.')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Info')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre de Pokémon'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async => await fetchPokemon(_controller.text.toLowerCase()),
              child: Text('Buscar Pokémon'),
            ),
            if (_pokemon != null)
              Column(
                children: [
                  Image.network(_pokemon!['sprites']['front_default']),
                  Text('Base Experience: ${_pokemon!['base_experience']}'),
                  Text('Abilities: ' +
                      (_pokemon!['abilities'] as List)
                          .map((e) => e['ability']['name'])
                          .join(', ')),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _playCry,
                        child: Text('Reproducir sonido'),
                      ),
                      SizedBox(width: 10),
                      if (_isPlaying) Icon(Icons.volume_up, color: Colors.green),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
