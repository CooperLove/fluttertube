import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/Blocs/FavoriteBloc.dart';
import 'package:fluttertube/Blocs/VideosBloc.dart';
import 'package:fluttertube/Delegates/DataSearch.dart';
import 'package:fluttertube/Screens/FavoritesScreen.dart';
import 'package:fluttertube/Tiles/VideoTile.dart';

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  // var videoBloc = BlocProvider.getBloc<VideosBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/YoutubeLogo.png"),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Align(
              alignment: Alignment.center,
              child: StreamBuilder(
                initialData: {},
                stream:
                    BlocProvider.getBloc<FavoriteBloc>().outFavorites.cast(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("${snapshot.data.length}");
                  }

                  return Text("0");
                },
              )),
          IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()));
              }),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String result =
                    await showSearch(context: context, delegate: DataSearch());
                print("Result: $result");
                if (result != null) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
                }
              }),
        ],
      ),
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length)
                    return VideoTile(snapshot.data[index]);
                  else if (index > 1) {
                    BlocProvider.getBloc<VideosBloc>().inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          }
          return Container();
        },
      ),
    );
  }
}
