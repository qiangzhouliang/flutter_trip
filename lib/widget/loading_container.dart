import 'package:flutter/material.dart';

///加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child; //具体呈现的内容
  final bool isLoading; //状态
  final bool cover; //是否覆盖整个页面的布局

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover ? !isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : Container()],
      );
  }

  Widget get _loadingView {
    return Center(
      //圆形进度条
      child: CircularProgressIndicator(),
    );
  }
}
