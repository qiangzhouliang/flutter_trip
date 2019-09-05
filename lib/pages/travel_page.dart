import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_tab_dao.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

/*旅拍*/
class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  //存储接口获取数据
  List<TravelTab> tabs = [];
  //类别
  TravelTabModel travelTabModel;
  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model){
      _controller = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e){
      print('e->$e');
    });
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: Column(
        children: <Widget>[
          //顶部tabbar
          _topTabBar,
          //页面显示的内容
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: tabs.map((TravelTab tab){
                return TravelTabPage(travelUrl: travelTabModel.url,params: travelTabModel.params,groupChannelCode: tab.groupChannelCode,);
              }).toList(),
            )
          )
        ],
      ),
    );
  }

  Widget get _topTabBar{
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 30),
      child: TabBar(
        controller: _controller,
        //允许左右滑动
        isScrollable: true,
        //设置label的颜色
        labelColor: Colors.black,
        labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
        //设置指示器
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xff2fcfbb),width: 3),
            insets: EdgeInsets.only(bottom: 10)
        ),
        tabs: tabs.map<Tab>((TravelTab tab){
          return Tab(text: tab.labelName,);
        }).toList(),
      ),
    );
  }
}