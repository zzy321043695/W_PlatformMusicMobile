/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-15 19:18:33
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2020-12-22 11:15:11
 */
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class NavigatorUtils {
  ///普通打开页面的方法
  ///[context] 上下文对象
  ///[targPage] 目标页面
  ///[isReplace] 是否替换当前页面  A - B
  static void pushPage({
    @required BuildContext context,
    @required Widget targPage,
    bool isReplace = false,
    Function(dynamic value) dismissCallBack,
  }) {
    PageRoute pageRoute;

    if (Platform.isAndroid) {
      pageRoute = MaterialPageRoute(builder: (BuildContext context) {
        return targPage;
      });
    } else {
      pageRoute = CupertinoPageRoute(builder: (BuildContext context) {
        return targPage;
      });
    }

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        dismissCallBack(value);
      });
    }
  }

  ///自定义打开页面的方法,渐变方式
  ///[context] 上下文对象
  ///[targPage] 目标页面
  ///[isReplace] 是否替换当前页面  A - B
  ///[opaque] 是否背景透明的方式打开
  static void pushPageByFade({
    @required BuildContext context,
    @required Widget targPage,
    bool isReplace = false,
    bool opaque = false,
    Function(dynamic value) dismissCallBack,
  }) {
    PageRoute pageRoute = PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return targPage;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        dismissCallBack(value);
      });
    }
  }
}
