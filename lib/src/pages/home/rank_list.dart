/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 14:07:57
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-25 10:35:06
 */

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/music/music_list.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class RankListPage extends StatefulWidget {
  @override
  _RankListPageState createState() {
    return _RankListPageState();
  }
}

class _RankListPageState extends State<RankListPage> {
  List<dynamic> rankList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtils.pushPage(context: context, targPage: MusicListPage());
      },
      child: Scaffold(
        body: FutureBuilder(
          future: Net.getHttp(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 请求已结束
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据
                Map<String, dynamic> responseData =
                    json.decode(snapshot.data.toString());
                LogUtils.e("数据");
                print(responseData['detail']['data']['data']['song'][5]);
                rankList = responseData['detail']['data']['data']['song'];
                print(rankList);
                return Column(
                  children: [
                    rankListItem(), //热歌榜
                  ],
                );
              }
            } else {
              // 请求未结束，显示loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: PopupMenuButton<String>(
          icon: Icon(Icons.add),
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'QQ',
                child: Text('QQ'),
              ),
              PopupMenuItem<String>(
                value: '网易',
                child: Text('网易'),
              ),
              PopupMenuItem<String>(
                value: '咪咕',
                child: Text('咪咕'),
              ),
            ];
          },
          onSelected: (String action) {
            switch (action) {
              case "QQ":
                print("QQ");
                break;
              case "网易":
                print("网易");
                break;
              case "咪咕":
                print("咪咕");
                break;
            }
          },
        ),
      ),
    );
  }

  Widget rankListItem() {
    return Container(
      margin: EdgeInsets.only(left: 22, right: 22),
      child: Container(
        height: 90,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
                  rankList[0]['albumMid'] +
                  '.jpg',
              height: 90,
              width: 90,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "热歌榜",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("1." +
                      rankList[0]['title'] +
                      " - " +
                      rankList[0]['singerName']),
                  Text("2." +
                      rankList[1]['title'] +
                      " - " +
                      rankList[1]['singerName']),
                  Text("3." +
                      rankList[2]['title'] +
                      " - " +
                      rankList[2]['singerName']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
