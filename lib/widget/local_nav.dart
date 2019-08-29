import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
// 1 无状态的组件，只是展示，没有交互
class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  //构造方法
  const LocalNav({Key key, @required this.localNavList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        //设置颜色
        color: Colors.white,
        //设置圆角
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }
  _items(BuildContext context){
    if(localNavList == null){
      return null;
    }

    List<Widget> items = [];
    localNavList.forEach((model){
      items.add(_item(context, model));
    });
    return Row(
      //平均排列MainAxisAlignment.spaceAround,中间平均MainAxisAlignment.spaceBetween
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }
  //每一个条目的内容
  Widget _item(BuildContext context,CommonModel commonModel){
    //GestureDetector 手势检测
    return GestureDetector(
      //点击事件
      onTap: (){

      },
      child: Column(
        children: <Widget>[
          Image.network(commonModel.icon,width: 32,height: 32,),
          Text(commonModel.title,style: TextStyle(fontSize: 12),)
        ],
      ),
    );
  }
}
