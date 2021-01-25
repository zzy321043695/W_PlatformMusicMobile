/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-10 10:39:15
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2020-12-16 10:36:39
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

///权限请求模版
class PermissionRequestWidget extends StatefulWidget {
  final Permission permission;
  final List<String> permissionList;
  final bool isCloseApp;
  final String leftButtonText;

  PermissionRequestWidget(
      {@required this.permission,
      @required this.permissionList,
      this.leftButtonText = "再考虑一下",
      this.isCloseApp = false});

  @override
  _PermissionRequestWidgetState createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget>
    with WidgetsBindingObserver {
  //页面的初始化函数
  @override
  void initState() {
    super.initState();
    checkPermisson();
    //注册观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isGoSetting) {
      checkPermisson();
    }
  }

  void checkPermisson({PermissionStatus status}) async {
    //权限
    Permission permission = widget.permission;

    if (status == null) {
      //权限状态
      status = await permission.status;
    }

    if (status.isUndetermined) {
      //第一次申请
      showPermissonAlert(widget.permissionList[0], "同意", permission);
    } else if (status.isDenied) {
      if (Platform.isIOS) {
        showPermissonAlert(widget.permissionList[2], "去设置中心", permission,
            isSetting: true);
        return;
      }
      //用户第一次申请拒绝
      showPermissonAlert(widget.permissionList[1], "重试", permission);
    } else if (status.isPermanentlyDenied) {
      //第二次申请 用户拒绝
      showPermissonAlert(widget.permissionList[2], "去设置中心", permission,
          isSetting: true);
    } else {
      //通过
      Navigator.of(context).pop(true);
    }
  }

  //是否去设置中心
  bool _isGoSetting = false;

  void showPermissonAlert(
      String message, String rightString, Permission permission,
      {bool isSetting = false}) {
    showCupertinoDialog(
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("温馨提示"),
            content: Container(
              padding: EdgeInsets.all(12),
              child: Text(message),
            ),
            actions: [
              //左边的按钮
              CupertinoDialogAction(
                child: Text("${widget.leftButtonText}"),
                onPressed: () {
                  if (widget.isCloseApp) {
                    closeApp();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              //右边的按钮
              CupertinoDialogAction(
                child: Text("$rightString"),
                onPressed: () {
                  //关闭弹框
                  Navigator.of(context).pop();
                  if (isSetting) {
                    _isGoSetting = true;
                    //去设置中心
                    openAppSettings();
                  } else {
                    //申请权限
                    requestPermiss(permission);
                  }
                },
              )
            ],
          );
        },
        context: context);
  }

  void requestPermiss(Permission permission) async {
    //发起权限申请
    PermissionStatus status = await permission.request();

    //校验
    checkPermisson();
  }

  void closeApp() {
    //关闭应用的方法
    SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }

  @override
  void dispose() {
    //注销观察者
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
    );
  }
}
