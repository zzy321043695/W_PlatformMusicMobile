/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 14:07:57
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-09 09:29:50
 */

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_source.dart';
import 'package:music_learn/src/pages/music/music_list.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';
import 'package:music_learn/src/widgets/music_rank_item.dart';
import 'package:music_learn/src/widgets/music_rank_item_kugou.dart';

class RankListPage extends StatefulWidget {
  @override
  _RankListPageState createState() {
    return _RankListPageState();
  }
}

class _RankListPageState extends State<RankListPage>
    with AutomaticKeepAliveClientMixin {
  //保持页面切换时的状态
  @override
  bool get wantKeepAlive => true;

  List<dynamic> rankList;
  String source = MusicSource.source;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = 105;
    LogUtils.e(MusicSource.source);

    return Scaffold(
      body: FutureBuilder(
        future: Net.getRankLists(MusicSource.source),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              //LogUtils.e("排行榜");
              LogUtils.e(MusicSource.source);
              return SingleChildScrollView(
                child: Column(
                  children: MusicSource.source == 'qq' //qq音乐
                      ? snapshot.data[0]['list'].map<Widget>((value) {
                          return MusicRankItem(
                            topId: value['id'].toString(),
                            rankName: value['topName'],
                            source: MusicSource.source,
                          );
                        }).toList()
                      : MusicSource.source == 'migu' //咪咕音乐
                          ? snapshot.data.map<Widget>((value) {
                              return MusicRankItem(
                                topId: value['id'].toString(),
                                rankName: value['topName'],
                                source: MusicSource.source,
                              );
                            }).toList()
                          : MusicSource.source == 'kuwo' //酷我音乐
                              ? snapshot.data[0]['list'].map<Widget>((value) {
                                  return MusicRankItem(
                                    topId: value['id'].toString(),
                                    rankName: value['topName'],
                                    source: MusicSource.source,
                                  );
                                }).toList()
                              : MusicSource.source == 'kugou' //酷狗音乐
                                  ? snapshot.data.map<Widget>((value) {
                                      return MusicRankItemKugou(
                                        topId: value['id'].toString(),
                                        source: MusicSource.source,
                                        rankName: value['topName'],
                                        picUrl: value['picUrl'],
                                      );
                                    }).toList()
                                  : MusicSource.source == 'wangyi' //网易音乐
                                      ? snapshot.data.map<Widget>((value) {
                                          return MusicRankItemKugou(
                                            topId: value['id'],
                                            source: MusicSource.source,
                                            rankName: value['topName'],
                                            picUrl: value['picUrl'],
                                          );
                                        }).toList()
                                      : Container(),
                ),
              );
            }
          } else {
            // 请求未结束，显示loading
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endDocked, 0, -56),
      floatingActionButton: PopupMenuButton<String>(
        // icon: Icon(Icons.add),
        child: currentMusicSource(MusicSource.source),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'QQ',
              child: Text('QQ'),
            ),
            PopupMenuItem<String>(
              value: '咪咕',
              child: Text('咪咕'),
            ),
            PopupMenuItem<String>(
              value: '酷我',
              child: Text('酷我'),
            ),
            PopupMenuItem<String>(
              value: '酷狗',
              child: Text('酷狗'),
            ),
            PopupMenuItem<String>(
              value: '网易',
              child: Text('网易'),
            ),
          ];
        },
        onSelected: (String action) {
          switch (action) {
            case "QQ":
              //print("QQ");
              setState(() {
                MusicSource.source = 'qq';
              });
              break;
            case "咪咕":
              //print("咪咕");
              setState(() {
                MusicSource.source = 'migu';
              });
              break;
            case "酷我":
              //print("酷我");
              setState(() {
                MusicSource.source = 'kuwo';
              });
              break;
            case "酷狗":
              //print("酷狗");
              setState(() {
                MusicSource.source = 'kugou';
              });
              break;
            case "网易":
              print("网易");
              setState(() {
                MusicSource.source = 'wangyi';
              });
              break;
          }
        },
      ),
    );
  }

  Widget rankListItem(double height) {
    return Container(
      margin: EdgeInsets.only(
        left: 1,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        // color: Colors.red,
        height: height,
        decoration: new BoxDecoration(
          /*  border:
                      new Border.all(color: Color(0xFFFF0000), width: 0.5), // 边色与边宽度 */
          color: Colors.white, // 底色
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
          /*  borderRadius: new BorderRadius.vertical(
                      top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小 */
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "热歌榜",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "1.   " +
                        rankList[0]['title'] +
                        " - " +
                        rankList[0]['singerName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "2.   " +
                        rankList[1]['title'] +
                        " - " +
                        rankList[1]['singerName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "3.   " +
                        rankList[2]['title'] +
                        " - " +
                        rankList[2]['singerName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.horizontal(
                    right: Radius.elliptical(10, 10)),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
                            rankList[0]['albumMid'] +
                            '.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget currentMusicSource(String source) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      child: source == 'qq'
          ? Text('QQ')
          : source == 'migu'
              ? Text('咪咕')
              : source == 'kuwo'
                  ? Text('酷我')
                  : source == 'kugou'
                      ? Text('酷狗')
                      : Text('网易'),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
