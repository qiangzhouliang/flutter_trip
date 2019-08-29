import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';
// 1 无状态的组件，只是展示，没有交互
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  //构造方法
  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //PhysicalModel 借助这个可以设置圆角
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      //是否裁切
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }
  //卡片内容
  _gridNavItems(BuildContext context){
    List<Widget> items = [];
    //卡片分为上中下三部分
    if(gridNavModel == null){
      return null;
    }
    //如果酒店不为空，就创建酒店的item
    if(gridNavModel.hotel != null){
      items.add(_gridNavItem(context,gridNavModel.hotel,true));
    }
    //如果机票不为空，就创建机票的item
    if(gridNavModel.flight != null){
      items.add(_gridNavItem(context,gridNavModel.flight,false));
    }
    //如果旅行不为空，就创建旅行的item
    if(gridNavModel.travel != null){
      items.add(_gridNavItem(context,gridNavModel.travel,false));
    }
    return items;
  }

  //每一个条目的内容，左中右三部分 first:标识是不是第一个
  _gridNavItem(BuildContext context,GridNavItem gridNavItem,bool first){
    List<Widget> items = [];
    //卡片分为左中右三部分
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1,gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3,gridNavItem.item4));
    List<Widget> expandItems = [];
    items.forEach((item){
      //让item水平垂直都填充父布局
      expandItems.add(Expanded(child: item,flex: 1,));
    });
    Color startColor = Color(int.parse("0xff${gridNavItem.startColor}"));
    Color endColor = Color(int.parse("0xff${gridNavItem.endColor}"));
    return Container(
      height: 88,
      margin: first? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //线性渐变
        gradient: LinearGradient(colors: [startColor,endColor])
      ),
      child: Row(children: expandItems,),
    );
  }

  //小卡片的左边大卡片部分
  _mainItem(BuildContext context,CommonModel model){
    return _wrapGesture(context, Stack(
      //设置内容顶部居中
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Image.network(model.icon,fit: BoxFit.contain,height: 88,width: 121,alignment: AlignmentDirectional.bottomEnd,),
        //padding 设置上边距
        Padding(padding: EdgeInsets.only(top: 11),child: Text(model.title,style: TextStyle(fontSize: 14,color: Colors.white),textAlign: TextAlign.center,),)
      ],
    ), model);
  }
  //包含了中间的两个小item
  _doubleItem(BuildContext context,CommonModel topItem,CommonModel bottomItem){
    return Column(
      children: <Widget>[
        // Expanded 这个是垂直方向填充父布局
        Expanded(child: _item(context, topItem, true),),
        Expanded(child: _item(context, bottomItem, false),)
      ],
    );
  }
  //里面小item的封装
  _item(BuildContext context,CommonModel item,bool first){
    //边框的样式
    BorderSide borderSide = BorderSide(width: 0.8,color: Colors.white);
    // FractionallySizedBox 水平方向填充父布局
    return FractionallySizedBox(
      //撑满父布局的宽度
      widthFactor: 1,
      child: _wrapGesture(context, Container(
        //样式
        decoration: BoxDecoration(
            border: Border(
              left: borderSide,
              bottom: first ? borderSide : BorderSide.none,
            )
        ),
        //内容
        child: Center(
          child: Text(item.title,textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.white),),
        ),
      ), item)
    );
  }
  //给 item提供点击事件
  _wrapGesture(BuildContext context,Widget widget,CommonModel model){
    return GestureDetector(
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
      child: widget,
    );
  }
}
