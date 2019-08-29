import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/webview.dart';
// 底部卡片入口
class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;

  //构造方法
  const SalesBox({Key key, @required this.salesBox}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //设置颜色
        color: Colors.white,
      ),
      child: _items(context),
    );
  }
  _items(BuildContext context){
    if(salesBox == null){
      return null;
    }

    List<Widget> items = [];
    items.add(_doubleItem(context,salesBox.bigCard1,salesBox.bigCard2,true,false));
    items.add(_doubleItem(context,salesBox.smallCard1,salesBox.smallCard2,false,false));
    items.add(_doubleItem(context,salesBox.smallCard3,salesBox.smallCard4,false,true));
    return Column(
      children: <Widget>[
       Container(
         height: 44,
         margin: EdgeInsets.only(left: 10),
         decoration: BoxDecoration(
           border: Border(bottom: BorderSide(width: 1,color: Color(0xfff2f2f2)))
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Image.network(salesBox.icon,height: 16,fit: BoxFit.fill,),
             Container(
               padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
               margin: EdgeInsets.only(right: 7),
               decoration: BoxDecoration(
                 //设置圆角
                 borderRadius: BorderRadius.circular(12),
                   gradient: LinearGradient(
                     colors: [Color(0xffff4e63),Color(0xffff6cc9),],
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                 )
               ),
               child: GestureDetector(
                 onTap: (){
                   Navigator.push(context,
                     MaterialPageRoute(builder: (context) => WebView(url: salesBox.moreUrl,title: '更多活动'))
                   );
                 },
                 child: Text('获取更多福利 >',style: TextStyle(fontSize: 12,color: Colors.white),),
               ),
             )
           ],
         ),
       ),
        //卡片内容
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0,1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1,2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2,3),
        )
      ],
    );
  }

  // last 是否是最后一个；big 是否是大卡片
  Widget _doubleItem(BuildContext context,CommonModel leftCard,CommonModel rightCard,bool big,bool last){
    return Row(
      //设置排列方式
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _item(context, leftCard,big,true,last),
        _item(context, rightCard,big,false,last)
      ],
    );
  }
  //每一个条目的内容
  Widget _item(BuildContext context,CommonModel model,bool big,bool left,bool last){
    BorderSide borderSide = BorderSide(width: 0.8,color: Color(0xfff2f2f2));
    //GestureDetector 手势检测
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: left ? borderSide : BorderSide.none,
            bottom: last ? BorderSide.none : borderSide,
          ),
        ),
        child: Image.network(
          model.icon,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width/2-10,
          height: big ? 129 : 80,
        ),
      ),
    );
  }
}
