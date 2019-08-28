import 'package:flutter/material.dart';

/**
 * 旅拍
 */
class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}
/**
 * _:可以定义为私有类，不被外界访问
 */
class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: Center(
        child: Text('旅拍'),
      ),
    );
  }
}