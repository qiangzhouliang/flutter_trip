import 'package:flutter/material.dart';

/**
 * 搜索页面
 */
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
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