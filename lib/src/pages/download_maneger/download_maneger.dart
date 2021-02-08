/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-08 10:41:56
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 10:55:32
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/utils/download_list_utils.dart';

class DownloadListPage extends StatefulWidget {
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<DownloadListPage> {
  Map musicAction = {};
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<MusicInfo> musicList = DownloadListUtils.musicList;
    print(musicList);
    return Scaffold(
      appBar: AppBar(
        title: Text("已下载的音乐"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return StoreConnector<MusicState, VoidCallback>(
            converter: (store) {
              return () => store.dispatch(handler(musicAction));
            },
            builder: (store, callback) {
              return new ListTile(
                title: new Text(
                  musicList[index].songName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(musicList[index].singerName),
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                onTap: () {
                  musicAction['type'] = MusicActions.newMusic;
                  MusicInfo musicInfo = musicList[index];
                  musicAction['musicInfo'] = musicInfo;
                  musicAction['currentMusicIndex'] = index;
                  musicAction['musicList'] = musicList;
                  callback();
                },
              );
            },
          );
        },
        itemCount: musicList.length,
      ),
      bottomNavigationBar: CustomBottomNavigationBarNotkey(),
    );
  }
}
