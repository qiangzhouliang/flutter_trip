import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: Center(
        //显示轮播图
        child: Column(
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
            )
          ],
        ),
      ),
    );
  }
}