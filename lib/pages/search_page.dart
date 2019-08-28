import 'package:flutter/material.dart';

/**
 * 搜索页面
 */
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
/**
 * _:可以定义为私有类，不被外界访问
 */
class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      body: Center(
        child: Text('搜索'),
      ),
    );
  }
}