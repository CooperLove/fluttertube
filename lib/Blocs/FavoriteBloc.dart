import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/Models/Video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc extends BlocBase {
  Map<String, Video> _favorites = {};

  final _favoritesController = BehaviorSubject<Map<String, Video>>();
  ValueStream<Map<String, Video>> get outFavorites =>
      _favoritesController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        _favorites = jsonDecode(prefs.getString("favorites")).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();

        _favoritesController.sink.add(_favorites);
      }
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
      print("Removendo ${video.title} dos favoritos");
    } else {
      _favorites[video.id] = video;
      print("Adicionandos ${video.title} aos favoritos");
    }

    _favoritesController.sink.add(_favorites);
    _saveFavorites();
  }

  void _saveFavorites() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", jsonEncode(_favorites));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _favoritesController.close();
  }
}
