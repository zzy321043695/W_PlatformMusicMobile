/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-19 16:29:35
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2020-12-24 15:22:08
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebViewPage extends StatefulWidget {
  final String htmlUrl;
  final String pageTitle;
  CommonWebViewPage({@required this.htmlUrl, this.pageTitle = ""});
  @override
  _CommonWebViewPageState createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.pageTitle}"),
        ),
        backgroundColor: Colors.white,
        body: WebView(
          initialUrl: widget.htmlUrl,
        ));
  }
}
