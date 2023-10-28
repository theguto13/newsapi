import 'package:flutter/material.dart';
import 'searchResultsScreen.dart';

class SearchScreen extends StatefulWidget {
  final Function(BuildContext, String, String, String, String, String, String)
      onSearch;

  SearchScreen({required this.onSearch});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Map<String, String> languageOptions = {
    'Inglês': 'en',
    'Espanhol': 'es',
    'Português': 'pt',
    'Francês': 'fr',
  };
  String selectedLanguage = 'Português';
  Map<String, String> searchInOptions = {
    'Título': 'title',
    'Descrição': 'description',
    'Tudo': '',
  };
  String selectedSearchIn = 'Título';
  Map<String, String> sortByOptions = {
    'Relevância': 'relevancy',
    'Popularidade': 'popularity',
    'Data de Publicação': 'publishedAt',
  };
  String selectedSortBy = 'Data de Publicação';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar notícias'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Color(0xFF8A2BE2),
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Palavras-chave',
                labelStyle: TextStyle(color: Color(0xFF8A2BE2)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8A2BE2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Color(0xFF8A2BE2),
              controller: fromController,
              decoration: InputDecoration(
                labelText: 'De (AAAA-MM-DD)',
                labelStyle: TextStyle(color: Color(0xFF8A2BE2)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8A2BE2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Color(0xFF8A2BE2),
              controller: toController,
              decoration: InputDecoration(
                labelText: 'Para (AAAA-MM-DD)',
                labelStyle: TextStyle(color: Color(0xFF8A2BE2)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8A2BE2)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Idioma: '),
              DropdownButton<String>(
                value: selectedLanguage,
                items: languageOptions.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Pesquisar em: '),
              DropdownButton<String>(
                value: selectedSearchIn,
                items: searchInOptions.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSearchIn = value!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Ordenar Por: '),
              DropdownButton<String>(
                value: selectedSortBy,
                items: sortByOptions.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSortBy = value!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  final query = searchController.text;
                  final keywords = query.split(' ');
                  final formattedQuery = keywords.join('+');
                  final from = fromController.text;
                  final to = toController.text;
                  String searchInValue =
                      searchInOptions[selectedSearchIn] ?? '';
                  String languageValue =
                      languageOptions[selectedLanguage] ?? '';
                  String sortByValue = sortByOptions[selectedSortBy] ?? '';
                  if (formattedQuery.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('O campo de pesquisa não pode estar vazio'),
                      ),
                    );
                  } else {
                    final apiKey = '476a48c286f14061bfa0758463c6b226';
                    final baseUrl =
                        'https://newsapi.org/v2/everything?apiKey=$apiKey';
                    String url = '$baseUrl&q=$formattedQuery';

                    if (from.isNotEmpty) {
                      url += '&from=$from';
                    }

                    if (to.isNotEmpty) {
                      url += '&to=$to';
                    }

                    if (searchInValue.isNotEmpty) {
                      url += '&searchIn=$searchInValue';
                    }

                    if (languageValue.isNotEmpty) {
                      url += '&language=$languageValue';
                    }

                    if (sortByValue.isNotEmpty) {
                      url += '&sortBy=$sortByValue';
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsScreen(url: url),
                      ),
                    );
                  }
                },
                child: Text('Pesquisar'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A2BE2)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
