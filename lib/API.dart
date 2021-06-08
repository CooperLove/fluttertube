import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Models/Video.dart';

const API_KEY = "AIzaSyC1FMY9icJ2hYzBUWT1d-B5Un6fgiUANrE";

class Api {
  void search(String search) async {
    Uri url = Uri.https("www.googleapis.com", "youtube/v3/search", {
      'part': "snippet",
      'q': "$search",
      'type': "video",
      'key': "$API_KEY",
      'maxResults': "10"
    });
    // print(url);
    http.Response response = await http.get(url);

    decode(response);
  }

  List<Video> decode(http.Response response) {
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      // print(decoded);
      List<Video> videos = decoded["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    }

    throw Exception("Failed to load videos!");
  }
}

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
