import 'package:flutter/material.dart';
import 'package:play_android/widget/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green, accentColor: Colors.greenAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '玩Android',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
          elevation: 0,
        ),
        body: TabNavigator(),
      ),
    );
  }
}
