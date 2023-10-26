import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './screens/descriptionScreen.dart';
import './screens/searchScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: NewsScreen(apiKey: '476a48c286f14061bfa0758463c6b226'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsScreen extends StatefulWidget {
  final String apiKey;

  NewsScreen({required this.apiKey});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Article> articles = [];
  int currentPage = 1;
  bool isLoading = false;
  final scrollController = ScrollController();

  void onSearch(BuildContext context, String query, String language,
      String sortBy, String from, String to, String searchIn) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          onSearch: onSearch,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNews(currentPage);
    scrollController.addListener(_onScroll);
  }

  Future<void> fetchNews(int page) async {
    if (isLoading || page > 2) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final apiKey = widget.apiKey;
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&page=$page&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articleList = (data['articles'] as List?) ?? [];
      setState(() {
        articles.addAll(articleList
            .map((article) => Article.fromJson(article))
            .where((article) => article.title != "[Removed]"));
        isLoading = false;
        currentPage++;
      });
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      fetchNews(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News API Notícias'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          if (article.title == "[Removed]") {
            return Container();
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: article),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(article.title),
                subtitle: Text(article.description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(onSearch: onSearch)));
        },
        child: Icon(Icons.search),
        backgroundColor: Color(0xFF8A2BE2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Article {
  final String title;
  final String description;
  final String author;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String source;
  final String formattedDate;

  Article({
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
    required this.formattedDate,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['publishedAt']);
    final formattedDate = DateFormat('HH:mm:ss - dd/MM/yyyy').format(dateTime);

    return Article(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      author: json['author'] as String? ?? '',
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      source: json['source']['name'] as String? ?? '',
      formattedDate: formattedDate,
    );
  }
}
