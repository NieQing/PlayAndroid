import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:play_android/common/base_config.dart';
import 'package:play_android/util/user_util.dart';
import 'package:play_android/model/user_model.dart';

const String loginUrl = '/user/login';

/// 用户相关数据访问层
class UserDAO {
  /// 获取登录用户数据
  static Future<UserModel> fetchUserInfo(String username, String password) async {

    var Params = {'username': username, 'password': password};

    final targetUrl = '${BaseConfig.BASE_URL}$loginUrl';

    debugPrint('${BaseConfig.TAG_USER_DAO}: \n$targetUrl');

    final response = await http.post(
        targetUrl,
        body: jsonEncode(Params),
        encoding: Encoding.getByName('utf-8')
    );

    UserUtil.token = response.headers['set-cookie'].substring(11, 43);

    debugPrint('${BaseConfig.LOG_USER_TOKEN}: \n${UserUtil.token}');

    if (response.statusCode == 200) {
      var result = json.decode(Utf8Decoder().convert(response.bodyBytes));
      return UserModel.fromJson(result);
    } else {
      throw Exception('Failed to load drawer_page.json');
    }
  }
}
