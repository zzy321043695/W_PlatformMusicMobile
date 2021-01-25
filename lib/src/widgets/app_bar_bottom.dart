/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-30 18:44:11
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2020-12-30 19:26:17
 */
import 'package:flutter/cupertino.dart';

class AppBarBottom extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  final Widget contentChild; //从外部指定内容
  final Color statusBarColor; //设置statusbar的颜色
  AppBarBottom(
      {@required this.contentChild,
      @required this.contentHeight,
      @required this.statusBarColor})
      : super();

  @override
  State<StatefulWidget> createState() {
    return new _AppBarBottomState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class _AppBarBottomState extends State<AppBarBottom> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: widget.statusBarColor,
      child: new SafeArea(
        top: true,
        child: widget.contentChild,
      ),
    );
  }
}
