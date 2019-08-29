import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
//滚动的最大值,阈值
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
///首页界面
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
///_:可以定义为私有类，不被外界访问
class _HomePageState extends State<HomePage> {
  //appbar透明度
  double appBarAlpha = 0;
  //保存获取到的数据
  List<CommonModel> bannerList = [];
  //保存获取到的数据
  List<CommonModel> localNavList = [];
  //活动集合
  List<CommonModel> subNavList = [];
  //卡片布局
  GridNavModel gridNavModel;
  //获取更多内容
  SalesBoxModel salesBox;
  //加载中变量值
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }
  //滚动处理操作
  _onScroll(offset){
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if(alpha < 0){
      //向上滚动
      alpha = 0;
    }else if(alpha > 1){
      //向下滚动
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e){
      print("err:$e");
      setState(() {
        _loading = false;
      });
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      //Stack 层叠组件，前面的元素在上面，后面的元素在下面
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            // MediaQuery 具有删除padding的属性
            MediaQuery.removePadding(
              //移除顶部padding
                removeTop: true,
                context: context,
                //下拉刷新
                child:RefreshIndicator(
                  onRefresh: _handleRefresh,
                  //NotificationListener 可以监听列表的滚动
                  child: NotificationListener(
                  //监听列表的滚动
                  // ignore: missing_return
                  onNotification: (scrollNotification){
                    //scrollNotification.depth 第0 个元素，也就是listview的第一个元素开始滚动的时候
                    if(scrollNotification is ScrollNotification && scrollNotification.depth == 0){
                      //滚动且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: _listView,
                ),
                )
            ),
            //导航条
            _appBar,
          ],
        ),

      )
    );
  }

  //提取 listview
  Widget get _listView{
    return ListView(
      children: <Widget>[
        //轮播图
        _banner,
        //首页导航区
        Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),child: LocalNav(localNavList: localNavList),),
        //卡片内容区
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: GridNav(gridNavModel: gridNavModel),),

        //活动入口
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: SubNav(subNavList: subNavList),),
        //获取更多和卡片内容
        Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: SalesBox(salesBox: salesBox),)
      ],
    );
  }

  Widget get _appBar{
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            //添加背景渐变效果
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            //设置上边距
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            //设置背景颜色
            decoration: BoxDecoration(color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        //底部阴影
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)])
        )
      ],
    );
  }

  //轮播图
  Widget get _banner {
    return //轮播图
      //是一个结合了绘制（painting）、定位（positioning）以及尺寸（sizing）widget的widget。
      Container(
        height: 160,
        //Swiper 轮播图组件
        child: Swiper(
          itemCount: bannerList.length, // 条目个数
          autoplay: true, //自动播放
          itemBuilder: (BuildContext context,index){
            //返回一个图片
            return GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        WebView(
                            url: bannerList[index].url,
                            statusBarColor: bannerList[index].statusBarColor,
                            title: bannerList[index].title,
                            hideAppBar: bannerList[index].hideAppBar
                        )
                    )
                );
              },
              child: Image.network(
                bannerList[index].icon,
                fit: BoxFit.fill,//适配方式，填充父窗体
              ),
            );
          },
          //添加指示器
          pagination: SwiperPagination(),
        ),
      );
  }

  //跳转到搜索页面
  _jumpToSearch(){
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  //跳转到语音页面
  _jumpToSpeak(){
//    NavigatorUtil.push(context, SpeakPage());
  }
}