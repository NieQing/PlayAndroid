import 'package:flutter/material.dart';
import 'package:play_android/common/base_config.dart';
import 'package:play_android/dao/home_dao.dart';
import 'package:play_android/model/article_model.dart';
import 'package:play_android/common/time_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleListModel> articles;
  int _pageNum = 0;
  bool _loadMore = true;
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData({loadMore = false}) {
    if (loadMore) {
      _pageNum++;
    } else {
      _pageNum = 0;
    }

    HomeDAO.fetchArticle(_pageNum).then((ArticleModel model) {
      _isLoading = false;
      setState(() {
        List<ArticleListModel> items = model.articleDataModel.datas;
        if (articles != null) {
          articles.addAll(items);
        } else {
          articles = items;
        }
      });
      debugPrint('${BaseConfig.TAG_HOME_DATA}: \n$articles');
    }).catchError((e) {
      _isLoading = false;
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Container(
        color: Colors.transparent,
        child: _buildList(),
      ),
    );
  }

  /// 构建文章列表
  _buildList() {
    return ListView.separated(
      controller: _scrollController,
      itemCount: articles?.length ?? 0,
      itemBuilder: (BuildContext context, int index) => _ArticleItem(
            index: index,
            length: articles?.length ?? 0,
            model: articles[index],
          ),
      separatorBuilder: (BuildContext context, int index) => _buildDivider(),
    );
  }

  /// 构建分割线
  _buildDivider() {
    return Divider(
      height: 1,
      indent: 10,
      color: Colors.grey[600],
    );
  }
}

/// 文章列表Item
class _ArticleItem extends StatelessWidget {
  final int index;
  final int length;
  final ArticleListModel model;

  const _ArticleItem({Key key, this.index, this.length, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: PhysicalModel(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildItemAuthorAndTime(),
              _buildItemTitle(),
              _buildItemTagAndBtn(),
            ],
          ),
        ),
      ),
    );
  }

  _buildItemAuthorAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        ),
        Text(
          TimeUtil.readTimestamp(model.publishTime),
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        ),
      ],
    );
  }

  _buildItemTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 10),
          width: 320,
          child: Text(
            model.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }

  _buildItemTagAndBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
              color: Colors.grey[600], borderRadius: BorderRadius.circular(3)),
          child: Text(
            model.chapterName,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    );
  }
}
