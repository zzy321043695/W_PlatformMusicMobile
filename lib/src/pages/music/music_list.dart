/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-23 10:51:18
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-23 18:21:57
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class MusicListPage extends StatefulWidget {
  @override
  _MusicListPageState createState() {
    return _MusicListPageState();
  }
}

class _MusicListPageState extends State<MusicListPage> {
  List<dynamic> musicList;
  List<dynamic> musicInfoList;
  Map musicAction = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              musicList = responseData['detail']['data']['data']['song'];
              musicInfoList = responseData['detail']['data']['songInfoList'];
              print(musicList);
              return new CustomScrollView(
                slivers: <Widget>[
                  new SliverAppBar(
                    title: Text("热歌榜"),
                    flexibleSpace: new FlexibleSpaceBar(
                      background: Image.network(
                        'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
                            musicList[0]['albumMid'] +
                            '.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: 275.0,
                      ),
                    ),
                    expandedHeight: 275.0,
                    floating: false, //滑动时是否悬浮
                    pinned: true,
                    snap: false,
                  ),
                  StoreConnector<MusicState, VoidCallback>(converter: (store) {
                    return () => store.dispatch(handler(musicAction));
                  }, builder: (store, callback) {
                    return new SliverFixedExtentList(
                      itemExtent: 50.0,
                      delegate: new SliverChildBuilderDelegate(
                        (context, index) => new ListTile(
                          title: new Text(musicList[index]['title']),
                          subtitle: Text(musicList[index]['singerName']),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: rankNumStyle(index),
                          ),
                          onTap: () async {
                            String songMid = musicInfoList[index]['mid'];

                            //将当前歌曲列表添加到播放列表
                            List<MusicInfo> musicList = List<MusicInfo>();
                            for (int i = 0; i < musicInfoList.length; i++) {
                              MusicInfo m = new MusicInfo(
                                  albumMid: musicInfoList[i]['album']['mid'],
                                  singerName: musicInfoList[i]['singer'][0]
                                      ['name'],
                                  songMid: musicInfoList[i]['mid'],
                                  songName: musicInfoList[i]['name']);
                              /* m.albumMid = musicInfoList[i]['album']['mid'];
                                m.singerName =
                                    musicInfoList[i]['singer'][0]['name'];
                                m.songMid = musicInfoList[i]['mid'];
                                m.songName = musicInfoList[i]['name']; */
                              musicList.add(m);
                            }
                            LogUtils.e("列表");
                            musicAction['type'] = MusicActions.newMusic;
                            MusicInfo musicInfo = new MusicInfo(
                              songName: musicInfoList[index]['name'],
                              songMid: songMid,
                              singerName: musicInfoList[index]['singer'][0]
                                  ['name'],
                              albumMid: musicInfoList[index]['album']['mid'],
                            );
                            musicAction['musicInfo'] = musicInfo;
                            musicAction['currentMusicIndex'] = index;
                            musicAction['musicList'] = musicList;

                            callback();
                          },
                          onLongPress: () {
                            // do something else
                          },
                        ),
                        childCount: 200,
                      ),
                    );
                  })
                ],
              );
            }
          } else {
            // 请求未结束,显示loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: new CustomBottomNavigationBarNotkey(),
    );
  }

  Widget rankNumStyle(int index) {
    if (index > 2) {
      return Text(
        "${index + 1}",
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else {
      return Text(
        "${index + 1}",
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }
  }
}
