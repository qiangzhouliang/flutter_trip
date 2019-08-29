
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
//滚动的最大值,阈值
const APPBAR_SCROLL_OFFSET = 100;
/**
 * 首页界面
 */
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
                  child: ListView(
                    children: <Widget>[
                      //轮播图
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
                      ),
                      //首页导航区
                      Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),child: LocalNav(localNavList: localNavList),),
                      //卡片内容区
                      Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: GridNav(gridNavModel: gridNavModel),),

                      //活动入口
                      Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: SubNav(subNavList: subNavList),),
                      //获取更多和卡片内容
                      Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),child: SalesBox(salesBox: salesBox),),
                      Container(
                        height: 800,
                        //ListTile 通常用于在 Flutter 中填充 ListView
                        child: ListTile(title: Text("resultString"),),
                      )
                    ],
                  ),
                ),
                )
            ),
            //导航栏 Opacity包裹，可以改变组件透明度
            Opacity(
              //必传参数
              opacity: appBarAlpha,
              child: Container(
                height: 80,
                //decoration 装饰器, 背景色为白色
                decoration: BoxDecoration(color: Colors.white,),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('首页'),
                  ),
                ),
              ),
            )
          ],
        ),

      )
    );
  }
}