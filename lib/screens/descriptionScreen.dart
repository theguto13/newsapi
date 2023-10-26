import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  Widget buildArticleImage() {
    if (article.urlToImage.isNotEmpty) {
      try {
        return Image.network(article.urlToImage);
      } catch (e) {
        print('Erro ao carregar a imagem: $e');
      }
    }
    return Container();
  }

  void _launchURL() async {
    final url = article.url;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Artigo'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Veículo: ${article.source}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Autor: ${article.author}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Publicado às: ${article.formattedDate}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(article.description),
              ),
              buildArticleImage(),
              Text(
                article.content,
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _launchURL,
                  child: Text('Ver artigo'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A2BE2)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
