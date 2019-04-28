import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:play_android/common/base_config.dart';
import 'package:play_android/util/navigator_util.dart';
import 'package:play_android/util/time_util.dart';
import 'package:play_android/dao/home_dao.dart';
import 'package:play_android/model/article_model.dart';
import 'package:play_android/model/banner_model.dart';
import 'package:play_android/widget/loading_container.dart';
import 'package:play_android/widget/webview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleListModel> articles = [];
  List<BannerListModel> banners = [];
  int _pageNum = 0;
  double _onTop = 0;
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _loadData(loadMore: true);
        }
      })
      ..addListener(() {
        if (_scrollController.offset == 0) {
          setState(() {
            _onTop = 0;
          });
        }
      })
      ..addListener(() {
        if (_scrollController.offset > 0) {
          setState(() {
            _onTop = 1;
          });
        }
      });
    _loadBanner();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 加载Banner
  void _loadBanner() {
    HomeDAO.fetchBanner().then((BannerModel model) {
      setState(() {
        List<BannerListModel> items = model.data;
        if (banners != null) {
          banners.clear();
          banners.addAll(items);
        } else {
          banners = items;
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  /// 加载文章列表
  void _loadData({loadMore = false}) {
    if (loadMore) {
      _pageNum++;
    } else {
      articles?.clear();
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

  /// 刷新业务
  Future<Null> _handleRefresh() async {
    _loadBanner();
    _loadData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        context: context,
        isLoading: _isLoading,
        child: RefreshIndicator(
            child: MediaQuery.removePadding(
                removeTop: true, context: context, child: _buildList()),
            onRefresh: _handleRefresh),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  /// 构建Banner
  _buildBanner() {
    return Container(
      height: 180.0,
      child: Swiper(
        itemCount: banners.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              BannerListModel model = banners[index];
              NavigatorUtil.push(
                  context,
                  WebViewWidget(
                    url: model.url,
                    title: model.title,
                  ));
            },
            child: Image.network(
              banners[index].imagePath,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  /// 构建文章列表
  _buildList() {
    return ListView.separated(
      controller: _scrollController,
      itemCount: articles.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index != 0) {
          return _ArticleItem(
            index: index - 1,
            length: articles.length,
            model: articles[index - 1],
          );
        } else {
          return _buildBanner();
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          _buildDivider(index),
    );
  }

  /// 构建分割线
  _buildDivider(int index) {
    if (index != 0) {
      return Divider(
        height: 1,
        indent: 10,
        color: Colors.grey[600],
      );
    } else {
      return Divider(
        height: 0,
        indent: 0,
        color: Colors.transparent,
      );
    }
  }

  /// 构建回顶按钮
  _buildFab() {
    return Opacity(
      opacity: _onTop,
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _scrollController.jumpTo(0);
          });
        },
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
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
      onTap: () {
        NavigatorUtil.push(
            context,
            WebViewWidget(
              url: model.link,
              title: model.title,
            ));
      },
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
        ),
        Opacity(
          opacity: model.userId == -1 ? 0 : 1,
          child: model.type == 0
              ? Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                )
              : Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                ),
        )
      ],
    );
  }
}
