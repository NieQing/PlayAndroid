import 'package:flutter/material.dart';
import 'package:play_android/pages/drawer_page.dart';
import 'package:play_android/widget/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green, accentColor: Colors.greenAccent),
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            '玩Android',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
          elevation: 0,
        ),
        body: TabNavigator(),
        drawer: DrawerPage(),
      )),
    );
  }
}
