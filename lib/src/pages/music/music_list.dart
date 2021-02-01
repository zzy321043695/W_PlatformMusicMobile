/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-23 10:51:18
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-31 20:21:58
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
  final String source;
  final List musicList;
  final String topName;
  MusicListPage(
      {@required this.source,
      @required this.musicList,
      @required this.topName});
  @override
  _MusicListPageState createState() {
    return _MusicListPageState();
  }
}

class _MusicListPageState extends State<MusicListPage> {
  /* List<dynamic> musicList;
  List<dynamic> musicInfoList; */
  Map musicAction = {};

  @override
  Widget build(BuildContext context) {
    //LogUtils.e(widget.source);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            title: Text(widget.topName),
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.network(
                widget.musicList[0]['albumPicUrl'],
                width: MediaQuery.of(context).size.width,
                height: 275.0,
              ),
            ),
            expandedHeight: 200.0,
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
                  title: new Text(widget.musicList[index]['songName']),
                  subtitle: Text(widget.musicList[index]['singerName']),
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: rankNumStyle(index),
                  ),
                  onTap: () async {
                    // String songMid = widget.musicList[index]['songMid'];

                    //将当前歌曲列表添加到播放列表
                    LogUtils.e('cuwu:' + widget.source);
                    List<MusicInfo> musicList = List<MusicInfo>();
                    for (int i = 0; i < widget.musicList.length; i++) {
                      MusicInfo m = new MusicInfo(
                        albumMid: widget.musicList[i]['albumMid'],
                        singerName: widget.musicList[i]['singerName'],
                        songMid: widget.musicList[i]['songMid'],
                        songName: widget.musicList[i]['songName'],
                        picUrl: widget.musicList[i]['albumPicUrl'],
                        source: widget.source,
                      );
                      /* m.albumMid = musicInfoList[i]['album']['mid'];
                                m.singerName =
                                    musicInfoList[i]['singer'][0]['name'];
                                m.songMid = musicInfoList[i]['mid'];
                                m.songName = musicInfoList[i]['name']; */
                      musicList.add(m);
                    }
                    //LogUtils.e("列表");
                    musicAction['type'] = MusicActions.newMusic;
                    MusicInfo musicInfo = new MusicInfo(
                      albumMid: widget.musicList[index]['albumMid'],
                      singerName: widget.musicList[index]['singerName'],
                      songMid: widget.musicList[index]['songMid'],
                      songName: widget.musicList[index]['songName'],
                      picUrl: widget.musicList[index]['albumPicUrl'],
                      source: widget.source,
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
                childCount: widget.musicList.length,
              ),
            );
          })
        ],
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
