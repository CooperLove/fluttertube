import 'package:flutter/material.dart';
import 'package:fluttertube/Models/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen(this.video, this._controller, {Key key}) : super(key: key);
  final Video video;
  final YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(video.title),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: player,
          ),
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          print("OnReady");
          // _controller.addListener(listener);
        },
      ),
    );
  }
}
