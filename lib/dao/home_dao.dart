import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:play_android/common/base_config.dart';
import 'package:play_android/model/article_model.dart';
import 'package:flutter/material.dart';

const String url = '/article/list/';

/// 主页数据访问层
class HomeDAO {
  /// 获取主页文章列表
  static Future<ArticleModel> fetchArticle(int pageNum) async {
    final targetUrl = '${BaseConfig.BASE_URL}$url$pageNum/json';
    debugPrint('${BaseConfig.TAG_HOME_DAO}: \n$targetUrl');
    final response = await http.get(targetUrl);
    if (response.statusCode == 200) {
      var result = json.decode(Utf8Decoder().convert(response.bodyBytes));
      return ArticleModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }

  /// 获取主页Banner
}
