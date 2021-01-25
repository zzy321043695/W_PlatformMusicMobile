/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-31 10:36:50
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-21 09:13:06
 */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class MusicListWidget extends StatefulWidget {
  final Map<String, dynamic> musicList;
  MusicListWidget(this.musicList);
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
      List<dynamic> musicInfoList = widget.musicList['list'];
      print(musicInfoList);
      return Scaffold(
        body: new ListView.builder(
          itemCount: musicInfoList.length,
          itemBuilder: (context, index) {
            return StoreConnector<MusicState, VoidCallback>(converter: (store) {
              return () => store.dispatch(handler(musicAction));
            }, builder: (store, callback) {
              return new ListTile(
                title: new Text(musicInfoList[index]['songname']),
                subtitle: Text(musicInfoList[index]['singer'][0]['name']),
                dense: true,
                onTap: () async {
                  String songMid = musicInfoList[index]['songmid'];

                  //将当前歌曲列表添加到播放列表
                  List<MusicInfo> musicList = List<MusicInfo>();
                  for (int i = 0; i < musicInfoList.length; i++) {
                    MusicInfo m = new MusicInfo(
                        albumMid: musicInfoList[i]['albummid'],
                        singerName: musicInfoList[i]['singer'][0]['name'],
                        songMid: musicInfoList[i]['songmid'],
                        songName: musicInfoList[i]['songname']);

                    musicList.add(m);
                  }

                  musicAction['type'] = MusicActions.newMusic;
                  MusicInfo musicInfo = new MusicInfo(
                    songName: musicInfoList[index]['songname'],
                    songMid: songMid,
                    singerName: musicInfoList[index]['singer'][0]['name'],
                    albumMid: musicInfoList[index]['albummid'],
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
