import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/Blocs/FavoriteBloc.dart';

import 'API.dart';
import 'Blocs/VideosBloc.dart';
import 'Screens/Home.dart';

void main() {
  Api api = Api();
  api.search("bleach");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: Home(),
        ),
        blocs: [Bloc((f) => FavoriteBloc()), Bloc((i) => VideosBloc())],
        dependencies: []);
  }
}
