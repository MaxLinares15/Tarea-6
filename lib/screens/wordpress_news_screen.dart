import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

class WordPressNewsScreen extends StatefulWidget {
  @override
  _WordPressNewsScreenState createState() => _WordPressNewsScreenState();
}

class _WordPressNewsScreenState extends State<WordPressNewsScreen> {
  List<dynamic> _posts = [];
  bool _loading = true;

  final String _logoUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/WordPress_blue_logo.svg/240px-WordPress_blue_logo.svg.png';

  final String _apiUrl = 'https://make.wordpress.org/core/wp-json/wp/v2/posts?per_page=3&_embed';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _posts = data;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress (The Next Web)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.network(
                        _logoUrl,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 60),
                      ),
                    ),
                    if (_posts.isEmpty)
                      const Text('No hay noticias disponibles.')
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          final title = post['title']['rendered'] ?? '';
                          final excerpt = post['excerpt']['rendered'] ?? '';
                          final link = post['link'] ?? '';

                          String? imageUrl;
                          try {
                            imageUrl = post['_embedded']['wp:featuredmedia'][0]['source_url'];
                          } catch (_) {
                            imageUrl = null;
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: InkWell(
                              onTap: () => _launchUrl(link),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageUrl != null)
                                      Image.network(
                                        imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                      ),
                                    const SizedBox(height: 12),
                                    Text(
                                      title,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Html(
                                      data: excerpt,
                                      style: {
                                        "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero)
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () => _launchUrl(link),
                                      child: const Text('Visitar'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
