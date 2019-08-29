import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];
//自定义浏览器组件
class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid; //是否禁止返回
  WebView({Key key, this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid = false}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  //创建实例
  final webviewReference = FlutterWebviewPlugin();
  //存储监听事件
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChange;
  StreamSubscription<WebViewHttpError> _onHttpError;
  //判断是否已经返回
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((url){

    });
    _onStateChange = webviewReference.onStateChanged.listen((WebViewStateChanged state){
      switch(state.type){
        case WebViewState.startLoad: //开始加载
          if (_isToMain(state.url) && !exiting) {
            //是否禁止返回
            if (widget.backForbid) {
              //打开当前页
              webviewReference.launch(widget.url);
            } else {
              //返回到上一页
              Navigator.pop(context);
              exiting = true;
            }
          }
         break;
        default:
          break;
      }
    });
    //加载错误监听
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error){
      print(error);
    });
  }
  //判断是否包含在白名单里面
  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }
  @override
  void dispose() {
    //取消注册监听
    _onUrlChanged.cancel();
    _onStateChange.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          //Expanded 撑满屏幕
          Expanded(
            // WebviewScaffold webview 插件封装的插件插件
              child: WebviewScaffold(
                userAgent: 'null',//防止携程H5页面重定向到打开携程APP ctrip://wireless/xxx的网址
                url: widget.url,
                withZoom: true,  //是否缩放
                withLocalStorage: true, //缓存
                hidden: true,  //默认是否隐藏
                //设置加载时的样式
                initialChild: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text('Waiting...'),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    //判断是否影藏 appbar
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    //非影藏
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      //FractionallySizedBox 撑满屏幕的宽度
      child: FractionallySizedBox(
        //widthFactor: 1 表示宽度撑满
        widthFactor: 1,
        //层叠组件
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {Navigator.pop(context);},
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close,color: backButtonColor,size: 26,),
              ),
            ),
            //设置标题，用绝对定位
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(widget.title ?? '',style: TextStyle(color: backButtonColor, fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }
}