import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/search_bar.dart';

/// 搜索页面
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    //Scaffold 实现了基本的 Material Design 布局结构
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          //搜索框
          SearchBar(hideLeft: true,defaultText: '哈哈',hint: '123',leftButtonClick: () {
            Navigator.pop(context);
          },onChanged: _onTextChange,)
        ],
      )
    );
  }

  _onTextChange(text){

  }
}