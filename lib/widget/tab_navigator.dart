import 'package:flutter/material.dart';
import 'package:play_android/pages/home_page.dart';
import 'package:play_android/pages/knowledge_page.dart';
import 'package:play_android/pages/navigator_page.dart';
import 'package:play_android/pages/project_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            KnowledgePage(),
            NavigatorPage(),
            ProjectPage(),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  /// 底部导航栏生成方法
  _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (int index) {
        _pageController.jumpToPage(index);
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        _bottomNavigationBarItem('首页', Icons.home, 0),
        _bottomNavigationBarItem('知识体系', Icons.book, 1),
        _bottomNavigationBarItem('导航', Icons.navigation, 2),
        _bottomNavigationBarItem('项目', Icons.list, 3),
      ],
    );
  }

  /// 底部导航按钮生成方法
  _bottomNavigationBarItem(String name, IconData iconData, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.grey,
      ),
      activeIcon: Icon(
        iconData,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        name,
        style: TextStyle(
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey),
      ),
    );
  }
}
