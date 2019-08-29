import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';
// 1 活动组件
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  //构造方法
  const SubNav({Key key, @required this.subNavList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //设置颜色
        color: Colors.white,
        //设置圆角
        borderRadius: BorderRadius.circular(6)
      ),
      child: Padding(padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }
  _items(BuildContext context){
    if(subNavList == null){
      return null;
    }

    List<Widget> items = [];
    subNavList.forEach((model){
      items.add(_item(context, model));
    });
    //计算出每一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
       Row(
          //平均排列MainAxisAlignment.spaceAround,中间平均MainAxisAlignment.spaceBetween
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate),
        ),
        Padding(padding: EdgeInsets.only(top: 10),
          child: Row(
            //平均排列MainAxisAlignment.spaceAround,中间平均MainAxisAlignment.spaceBetween
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate),
          ),
        )
      ],
    );
  }
  //每一个条目的内容
  Widget _item(BuildContext context,CommonModel model){
    //GestureDetector 手势检测
    return Expanded(
      flex: 1,
      child: GestureDetector(
        //点击事件
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  WebView(
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      title: model.title,
                      hideAppBar: model.hideAppBar
                  )
              )
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(model.icon,width: 18,height: 18,),
            Padding(padding: EdgeInsets.only(top: 3),
              child: Text(model.title,style: TextStyle(fontSize: 12),),
            )
          ],
        ),
      )
    );
  }
}
