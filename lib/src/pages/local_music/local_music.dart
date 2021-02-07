/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-07 16:02:46
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-07 17:00:44
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_learn/src/pages/config/app_varies.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/utils/local_file_utils.dart';

class LocalMusicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LocalMusicPageState();
  }
}

class _LocalMusicPageState extends State<LocalMusicPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
        future: LocalFileUtils.getLocalMusicList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              //LogUtils.e("排行榜");
              return Scaffold(
                appBar: AppBar(
                  title: Text("本地音乐"),
                ),
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    String musicPath = snapshot.data[index];
                    String musicName =
                        musicPath.replaceAll(AppVaries.savePath, '');
                    return ListTile(
                      title: new Text(
                        musicName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
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
                        MusicController.audioPlayer.play(
                          musicPath,
                          isLocal: true,
                        );
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                ),
                bottomNavigationBar: CustomBottomNavigationBarNotkey(),
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
    );
  }
}
