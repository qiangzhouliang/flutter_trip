import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
// 1 无状态的组件，只是展示，没有交互
/*class GridNav extends StatelessWidget {
  final String name;

  //构造方法
  const GridNav({Key key, @required this.gridNavModel,this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text('gridNav');
  }
}*/
// 2 无状态的组件，只是展示，没有交互
class GridNav extends StatefulWidget {
  final GridNavModel gridNavModel;
  final String name;

  //构造方法,name 带有默认值
  const GridNav({Key key, @required this.gridNavModel,this.name = 'xiaoming'}) : super(key: key);
  @override
  _GridNavState createState() => _GridNavState();
}
class _GridNavState extends State<GridNav>{
  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
}