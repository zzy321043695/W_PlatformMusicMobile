/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-01-22 12:01:08
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 09:43:18
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/utils/favorite_list_utils.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class FavoriteListPage extends StatefulWidget {
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  Map musicAction = {};
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("我喜欢的音乐"),
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
                  FavoriteListUtils.musicList[index].songName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(FavoriteListUtils.musicList[index].singerName),
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
                  String songMid = FavoriteListUtils.musicList[index].songMid;

                  musicAction['type'] = MusicActions.newMusic;
                  MusicInfo musicInfo = FavoriteListUtils.musicList[index];
                  musicAction['musicInfo'] = musicInfo;
                  musicAction['currentMusicIndex'] = index;
                  musicAction['musicList'] = FavoriteListUtils.musicList;

                  callback();
                },
              );
            },
          );
        },
        itemCount: FavoriteListUtils.musicList.length,
      ),
      bottomNavigationBar: CustomBottomNavigationBarNotkey(),
    );
  }
}
