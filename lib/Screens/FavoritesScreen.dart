import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/Blocs/FavoriteBloc.dart';
import 'package:fluttertube/Models/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'VideoScreen.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: BlocProvider.getBloc<FavoriteBloc>().outFavorites.cast(),
        initialData: {},
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.values.map((v) {
                return InkWell(
                  splashFactory: InkRipple.splashFactory,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoScreen(v, initializeController(v.id))));
                  },
                  onLongPress: () {
                    BlocProvider.getBloc<FavoriteBloc>().toggleFavorite(v);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 100,
                        child: Image.network(v.thumb),
                      ),
                      Expanded(
                          child: Text(
                        v.title,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white70),
                      ))
                    ],
                  ),
                );
              }).toList(),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.redAccent),
            ),
          );
        },
      ),
    );
  }

  YoutubePlayerController initializeController(String videoId) {
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        // mute: true,
      ),
    );
  }
}
