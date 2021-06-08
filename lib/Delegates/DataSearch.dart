import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? Container()
        : FutureBuilder<List>(
            future: suggestions(query),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data[index]),
                          leading: Icon(Icons.play_arrow),
                          onTap: () {
                            close(context, snapshot.data[index]);
                          },
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            });
  }

  Future<List> suggestions(String search) async {
    Uri url = Uri.https("suggestqueries.google.com", "complete/search", {
      'hl': 'en',
      'ds': 'yt',
      'client': 'youtube',
      'hjson': 't',
      'cp': '1',
      'q': "$search",
      'format': '5',
      'alt': 'json'
    });
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[1].map((sug) {
        return sug[0];
      }).toList();
    } else {
      throw Exception("Failed to load suggestions!");
    }
  }
}
