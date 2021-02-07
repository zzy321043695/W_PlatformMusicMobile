/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-31 10:36:50
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-05 11:06:39
 */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class MusicListWidget extends StatefulWidget {
  final List musicList;
  final String source;
  MusicListWidget(this.musicList, this.source);
  @override
  _MusicListState createState() {
    return _MusicListState();
  }
}

class _MusicListState extends State<MusicListWidget> {
  // GlobalKey<CustomBottomNavigationBarState> textkey1 = GlobalKey();
  Map musicAction = {};
  @override
  Widget build(BuildContext context) {
    if (widget.musicList == null || widget.musicList.isEmpty) //音乐列表为空
      return Container();
    else {
      List musicInfoList = widget.musicList;
      //print(musicInfoList);
      return Scaffold(
        body: new ListView.builder(
          itemCount: musicInfoList.length,
          itemBuilder: (context, index) {
            return StoreConnector<MusicState, VoidCallback>(converter: (store) {
              return () => store.dispatch(handler(musicAction));
            }, builder: (store, callback) {
              return new ListTile(
                title: new Text(musicInfoList[index]['songName']),
                subtitle: Text(musicInfoList[index]['singerName']),
                dense: true,
                onTap: () async {
                  String songMid = musicInfoList[index]['songMid'];

                  //将当前歌曲列表添加到播放列表
                  List<MusicInfo> musicList = <MusicInfo>[];
                  for (int i = 0; i < musicInfoList.length; i++) {
                    MusicInfo m = new MusicInfo(
                      albumMid: musicInfoList[i]['albumMid'],
                      singerName: musicInfoList[i]['singerName'],
                      songMid: musicInfoList[i]['songMid'],
                      songName: musicInfoList[i]['songName'],
                      picUrl: musicInfoList[i]['albumPicUrl'],
                      hash: widget.musicList[i]['hash'],
                      source: widget.source,
                    );

                    musicList.add(m);
                  }

                  musicAction['type'] = MusicActions.newMusic;
                  MusicInfo musicInfo = new MusicInfo(
                    albumMid: musicInfoList[index]['albumMid'],
                    singerName: musicInfoList[index]['singerName'],
                    songMid: musicInfoList[index]['songMid'],
                    songName: musicInfoList[index]['songName'],
                    picUrl: musicInfoList[index]['albumPicUrl'],
                    hash: widget.musicList[index]['hash'],
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
              );
            });
          },
        ),
      );
    }
  }
}
