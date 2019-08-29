import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
//滚动的最大值,阈值
const APPBAR_SCROLL_OFFSET = 100;
/**
 * 首页界面
 */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
/**
 * _:可以定义为私有类，不被外界访问
 */
class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'http://pic33.nipic.com/20131007/13639685_123501617185_2.jpg',
    'http://pic1.win4000.com/wallpaper/c/53cdd1f7c1f21.jpg',
    'http://pic16.nipic.com/20111006/6239936_092702973000_2.jpg'
  ];
  //appbar透明度
  double appBarAlpha = 0;
  //保存从后端请求的结果
  String resultString = "";

  @override
  void initState() {
    super.initState();
    loadData();
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
  loadData() async {
    /*HomeDao.fetch().then((result){
      setState(() {
        resultString = json.encode(result);
      });
    }).catchError((error){
      setState(() {
        resultString = json.encode(error);
      });
    });*/
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model.config);
      });
    } catch (e){
      setState(() {
        resultString = json.encode(e);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      //Stack 层叠组件，前面的元素在上面，后面的元素在下面
      body: Stack(
        children: <Widget>[
          // MediaQuery 具有删除padding的属性
          MediaQuery.removePadding(
            //移除顶部padding
              removeTop: true,
              context: context,
              //NotificationListener 可以监听列表的滚动
              child:NotificationListener(
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
                    //是一个结合了绘制（painting）、定位（positioning）以及尺寸（sizing）widget的widget。
                    Container(
                      height: 160,
                      //Swiper 轮播图组件
                      child: Swiper(
                        itemCount: _imageUrls.length, // 条目个数
                        autoplay: true, //自动播放
                        itemBuilder: (BuildContext context,index){
                          //返回一个图片
                          return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.fill,//适配方式，填充父窗体
                          );
                        },
                        //添加指示器
                        pagination: SwiperPagination(),
                      ),
                    ),
                    GridNav(gridNavModel: null,name: 'xiaoming',),
                    Container(
                      height: 800,
                      //ListTile 通常用于在 Flutter 中填充 ListView
                      child: ListTile(title: Text(resultString),),
                    )
                  ],
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
      )
    );
  }
}