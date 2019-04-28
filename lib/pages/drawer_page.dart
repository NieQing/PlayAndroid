import 'package:flutter/material.dart';
import 'package:play_android/pages/favorite_page.dart';
import 'package:play_android/pages/setting_page.dart';
import 'package:play_android/pages/todo_page.dart';
import 'package:play_android/util/navigator_util.dart';
import 'package:play_android/util/user_util.dart';
import 'package:play_android/dao/user_dao.dart';
import 'package:play_android/model/user_model.dart';

/// 抽屉页面
class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  void _loadUserInfo() {
    UserDAO.fetchUserInfo('nieking', 'Junzj1994').then((UserModel model) {
      setState(() {
        UserUtil.user = model.data;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(UserUtil.user?.username ?? '',
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(UserUtil.user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: UserUtil.user?.icon == null
                  ? AssetImage('images/avatar_default.png')
                  : NetworkImage(UserUtil.user.icon),
            ),
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              image: DecorationImage(
                image: NetworkImage(
                    'https://resources.ninghao.org/images/childhood-in-a-picture.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.yellow[400].withOpacity(0.6), BlendMode.hardLight),
              ),
            ),
          ),
          _buildTile('收藏', Icons.favorite, FavoritePage()),
          _buildTile('TODO', Icons.playlist_add_check, TodoPage()),
          _buildTile('设置', Icons.settings, SettingPage()),
          _buildTile('登出', Icons.power_settings_new, SettingPage()),
        ],
      ),
    );
  }

  _buildTile(String title, IconData iconData, Widget page) {
    return ListTile(
      title: Text(title),
      leading: Icon(iconData),
      onTap: () {
        NavigatorUtil.pop(context);
        Future.delayed(Duration(milliseconds: 300), () {
          NavigatorUtil.push(context, page);
        });
      },
    );
  }
}
