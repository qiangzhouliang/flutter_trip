import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

/**
 * 导航栏组件，继承自有状态的组件 StatefulWidget
 */
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}
/**
 * _:可以定义为私有类，不被外界访问
 */
class _TabNavigatorState extends State<TabNavigator> {
  //选中的颜色和未选中的颜色
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  //当前选中值
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        // 这个里面就是要显示的界面
        children: <Widget>[
          //首页
          HomePage(),
          //搜索
          SearchPage(),
          //旅拍
          TravelPage(),
          // 我的
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //设置当前选中的是哪一个
        currentIndex: _currentIndex,
        //点击改变状态值
        onTap: (index){
          //设置当前选中页面
          _controller.jumpToPage(index);
          //在这里面改变状态值
          setState(() {
            _currentIndex = index;
          });
        },
        //将label固定，无论选中不选择，让字体都显示出来
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _defaultColor,),
            activeIcon: Icon(Icons.home,color: _activeColor,),
            title: Text('首页',style: TextStyle(color:_currentIndex !=0?_defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,color: _defaultColor,),
              activeIcon: Icon(Icons.search,color: _activeColor,),
              title: Text('搜索',style: TextStyle(color:_currentIndex !=1 ? _defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt,color: _defaultColor,),
              activeIcon: Icon(Icons.camera_alt,color: _activeColor,),
              title: Text('旅拍',style: TextStyle(color:_currentIndex !=2 ? _defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,color: _defaultColor,),
              activeIcon: Icon(Icons.account_circle,color: _activeColor,),
              title: Text('我的',style: TextStyle(color:_currentIndex !=3 ? _defaultColor : _activeColor),)
          )
        ],
      ),
    );
  }
}