/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-01-22 12:01:08
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-29 19:53:42
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
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
                  FavoriteMusicState.favoriteList[index].songName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                subtitle:
                    Text(FavoriteMusicState.favoriteList[index].singerName),
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
                  String songMid =
                      FavoriteMusicState.favoriteList[index].songMid;

                  //将当前歌曲列表添加到播放列表
                  // List<MusicInfo> musicList = List<MusicInfo>();

                  //LogUtils.e("列表");
                  musicAction['type'] = MusicActions.newMusic;
                  MusicInfo musicInfo = FavoriteMusicState.favoriteList[index];
                  /* new MusicInfo(
                    songName: FavoriteMusicState.favoriteList[index].songName,
                    songMid: songMid,
                    singerName:
                        FavoriteMusicState.favoriteList[index].singerName,
                    albumMid: FavoriteMusicState.favoriteList[index].albumMid,
                    source: FavoriteMusicState.favoriteList[index].source,
                    picUrl: FavoriteMusicState.favoriteList[index].picUrl,
                  ); */
                  musicAction['musicInfo'] = musicInfo;
                  musicAction['currentMusicIndex'] = index;
                  musicAction['musicList'] = FavoriteMusicState.favoriteList;

                  callback();
                },
              );
            },
          );
          //return  /* Text(FavoriteMusicState.favorite.musicList[index].songName); */
        },
        itemCount: FavoriteMusicState.favoriteList.length,
      ),
      bottomNavigationBar: CustomBottomNavigationBarNotkey(),
    );
  }
}
