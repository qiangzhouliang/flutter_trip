import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: Center(
        child: Text('首页'),
      ),
    );
  }
}