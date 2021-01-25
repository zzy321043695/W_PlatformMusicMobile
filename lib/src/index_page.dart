/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 09:54:26
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-12 15:14:38
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_learn/src/pages/common/permission_request_widget.dart';
import 'package:music_learn/src/pages/common/protocol_model.dart';
import 'package:music_learn/src/pages/home/main.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';
import 'package:music_learn/src/utils/sp_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State with ProtocolModel {
  List<String> _list = [
    "为您更好的体验应用，所以需要获取您的手机文件存储权限，以保存您的一些偏好设置",
    "您已拒绝权限，所以无法保存您的一些偏好设置，将无法使用APP",
    "您已拒绝权限，请在设置中心中同意APP的权限请求",
    "其他错误",
  ];

  @override
  void initState() {
    super.initState();

    //将任务添加到从队列中，等待视图加载完就会立即执行此任务
    Future.delayed(
      Duration.zero,
      () {
        initData();
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    LogUtils.e('结束');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/book.png"),
      ),
    );
  }

  void initData() {
    //当前应用的运行环境
    //当app运行在release环境时
    bool isLog = !bool.fromEnvironment("dart.vm.product");
    LogUtils.init(islog: isLog);
    LogUtils.e("权限申请");
    //权限申请
    NavigatorUtils.pushPageByFade(
      context: context,
      //目标页面
      targPage: PermissionRequestWidget(
        //所需要申请的权限
        permission: Permission.storage,
        //显示关闭应用按钮
        isCloseApp: true,
        //提示文案
        permissionList: _list,
      ),
      //权限申请的结果
      dismissCallBack: (value) {
        LogUtils.e("权限申请结果 $value");

        initDataNext();
      },
    );
  }

  //初始化工具类
  void initDataNext() async {
    if (Platform.isIOS) {
      Directory libDire = await getLibraryDirectory();
      LogUtils.e("libDire ${libDire.path}");
    }
    //初始化
    await SPUtil.init();
    //读取一下标识
    bool isAgrement = await SPUtil.getBool("isAgrement");

    LogUtils.e("isAgrement $isAgrement");

    if (isAgrement == null || !isAgrement) {
      isAgrement = await showProtocolFunction(context);
    }

    if (isAgrement) {
      //同意
      LogUtils.e("同意协议");

      //保存一下标识
      SPUtil.save("isAgrement", true);

      next();
    } else {
      LogUtils.e("不同意");
      closeApp();
    }
  }

  void closeApp() {
    SystemChannels.platform.invokeMapMethod("SystemNavigator.pop");
  }

  void next() {
    NavigatorUtils.pushPageByFade(
      context: context,
      targPage: MainPage(),
      isReplace: true,
    );
  }
}
