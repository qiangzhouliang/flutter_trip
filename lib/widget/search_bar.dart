import 'package:flutter/material.dart';
//枚举 指定searchbar的类型
enum SearchBarType { home, normal, homeLight }
/// 搜索自定义组件
class SearchBar extends StatefulWidget {
  final bool enabled;  //是否禁止搜索
  final bool hideLeft;  //左边按钮是否隐藏
  final SearchBarType searchBarType;  //搜索框类型
  final String hint;  //默认提示文案
  final String defaultText;
  final void Function() leftButtonClick; //左边button的监听事件
  final void Function() rightButtonClick; //右边button的监听事件
  final void Function() speakClick;      //语音按钮的点击回调
  final void Function() inputBoxClick;   //输入框的回调
  final ValueChanged<String> onChanged;  //内容变化的回调

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  //是否显示清除按钮
  bool showClear = false;
  //获取输入框的控制器
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //根据不同的枚举类型设置不同的样式
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
      child: Row(children: <Widget>[
        //左边部分
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget?.hideLeft ?? false
                  ? null
                  : Icon(Icons.arrow_back_ios,color: Colors.grey,size: 26,),
            ),
            widget.leftButtonClick),
        //中间部分
        Expanded(
          flex: 1,
          child: _inputBox(),
        ),
        //右边部分
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('搜索',style: TextStyle(color: Colors.blue, fontSize: 17),),
            ),
            widget.rightButtonClick)
      ]),
    );
  }

  _genHomeSearch() {
    return Container(
      child: Row(children: <Widget>[
        _wrapTap(
            Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    //左边
                    Text('上海',style: TextStyle(color: _homeFontColor(), fontSize: 12),),
                    //右边图片
                    Icon(Icons.expand_more,color: _homeFontColor(),size: 22,)
                  ],
                )),
            widget.leftButtonClick),
        //中间内容
        Expanded(flex: 1,child: _inputBox(),),
        //右边部分
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Icon(Icons.comment,color: _homeFontColor(),size: 26,),
            ),
            widget.rightButtonClick)
      ]),
    );
  }

  //中间内容部分
  _inputBox() {
    //输入框的颜色
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9) : Colors.blue,
          ),
          //输入框
          Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal
                  ? TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      autofocus: true,
                      style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.w300),
                      //输入文本的样式
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: widget.hint ?? '',
                        hintStyle: TextStyle(fontSize: 12),
                      ))
                  : _wrapTap(
                      Container(
                        child: Text(
                          widget.defaultText,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      widget.inputBoxClick)),
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(
                  Icon(Icons.clear,size: 22,color: Colors.grey,), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
