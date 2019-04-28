import 'package:flutter/material.dart';

/// 页面导航工具
class NavigatorUtil {
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }
}
