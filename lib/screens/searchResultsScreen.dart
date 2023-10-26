import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../screens/descriptionScreen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String url;

  SearchResultsScreen({required this.url});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Article> articles = [];
  int currentPage = 1;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchResults(currentPage);
    scrollController.addListener(_onScroll);
  }

  Future<void> fetchResults(int page) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = widget.url + "&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articleList = (data['articles'] as List?) ?? [];
      setState(() {
        articles.addAll(articleList
            .map((article) => Article.fromJson(article))
            .where((article) => article.title != "[Removed]"));
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      currentPage++;
      fetchResults(currentPage);
    }
  }

  void openArticleDescription(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados da pesquisa'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return InkWell(
            onTap: () {
              openArticleDescription(article);
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
    );
  }
}
