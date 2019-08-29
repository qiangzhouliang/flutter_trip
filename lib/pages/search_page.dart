import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/search_bar.dart';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
/// 搜索页面
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage(
      {Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint})
      : super(key: key);
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
          SearchBar(hideLeft: true,defaultText: '哈哈',hint: widget.hint,leftButtonClick: () {
            Navigator.pop(context);
          },onChanged: _onTextChange,)
        ],
      )
    );
  }

  _onTextChange(text){

  }
}