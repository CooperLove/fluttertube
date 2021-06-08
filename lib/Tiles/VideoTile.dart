import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/Blocs/FavoriteBloc.dart';
import 'package:fluttertube/Models/Video.dart';

class VideoTile extends StatelessWidget {
  const VideoTile(this.video, {Key key}) : super(key: key);
  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(
              video.thumb,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    video.channel,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ],
              )),
              StreamBuilder(
                  stream:
                      BlocProvider.getBloc<FavoriteBloc>().outFavorites.cast(),
                  initialData: {},
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? IconButton(
                            icon: Icon(snapshot.data.containsKey(video.id)
                                ? Icons.star
                                : Icons.star_border),
                            onPressed: () {
                              BlocProvider.getBloc<FavoriteBloc>()
                                  .toggleFavorite(video);
                            },
                            color: Colors.white,
                            iconSize: 30.0,
                          )
                        : Container();
                  })
            ],
          ),
        ],
      ),
    );
  }
}
