/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 12:00:14
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-09 09:28:43
 */
import 'package:flutter/material.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/download_maneger/download_maneger.dart';
import 'package:music_learn/src/pages/local_music/local_music.dart';

import 'package:music_learn/src/pages/play_list/favorite_list.dart';
import 'package:music_learn/src/pages/recent/recent.dart';
import 'package:music_learn/src/utils/favorite_list_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  //保持页面切换时的状态
  @override
  bool get wantKeepAlive => true;

  List<String> menuList = ["本地音乐", "最近播放", "下载管理"];
  List<IconData> iconList = [
    Icons.library_music,
    Icons.video_library,
    Icons.cloud_download,
  ];
  List<MusicInfo> mlist = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    print(mlist.length);
    return Column(
      children: [
        menuItem(
          type: "first",
          icon: iconList[0],
          text: menuList[0],
          onTap: () {
            NavigatorUtils.pushPage(
                context: context, targPage: LocalMusicPage());
          },
        ),
        menuItem(
          type: "other",
          icon: iconList[1],
          text: menuList[1],
          onTap: () {
            NavigatorUtils.pushPage(
                context: context, targPage: RecentListPage());
          },
        ),
        menuItem(
          type: "end",
          icon: iconList[2],
          text: menuList[2],
          onTap: () {
            NavigatorUtils.pushPage(
                context: context, targPage: DownloadListPage());
          },
        ),
        Container(
          height: 10,
          color: Colors.grey[350],
        ),
        ExpansionTile(
          title: Text('创建的歌单'),
          // leading: Icon(Icons.ac_unit),
          backgroundColor: Colors.white12,
          children: <Widget>[
            ListTile(
              title: Text('喜欢的音乐'),
              subtitle:
                  Text(FavoriteListUtils.musicList.length.toString() + '首音乐'),
              leading: Icon(Icons.favorite),
              onTap: () {
                /* MusicInfo m = MusicInfo(songMid: 'sM');
                LocalCacheLoader('sm').saveById("uuid", {'1': m});
                //print(LocalCacheLoader('sm').all.map<MusicInfo>(
                      (cache) => cache.value['uuid'].songMid,
                    )); */

                /* LocalCacheLoader('aa').saveById("uuid", {
                  '1': ["ss", 'aa'],
                  '2': "dd",
                  '3': "dd3"
                }); */ //id相同就覆盖，不同就叠加，aa是channel
                /* LocalCacheLoader('aa')
                    .saveById("uuid", {'1': "ss", '2': "ddd"}); */
                // LocalCacheLoader('aa').clearAll();
                /* //print(LocalCacheLoader('aa')
                    .all
                    .map(
                      (cache) => cache.value['3'],
                    )
                    .toList()); */
                NavigatorUtils.pushPage(
                  context: context,
                  targPage: FavoriteListPage(),
                );
              },
            ),
          ],
          initiallyExpanded: true, //打开状态  不写默认false闭合状态
        ),
      ],
    );
  }
}

//自定义菜单项
Widget menuItem({String type, IconData icon, String text, Function onTap}) {
  return new Ink(
    child: InkWell(
      child: Container(
        decoration: type == "first"
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                ),
              )
            : type == "end"
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  )
                : BoxDecoration(),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 50,
            ),
            Icon(
              icon,
              size: 35,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: type == "end"
                    ? BoxDecoration()
                    : BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    ),
  );
}

//歌单类
class PlayList {}

Widget _buildPanel1() {
  return Column(
    children: [Text("我喜欢的音乐")],
  );
}

Widget _buildPanel2() {
  return Column(
    children: [Text("我喜欢的音乐")],
  );
}
