/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-24 15:15:33
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-25 11:00:04
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/pages/music/music_play.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class CustomBottomNavigationBarNotkey extends StatefulWidget {
  // 接收一个Key

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBarNotkey> {
  @override
  Widget build(BuildContext context) {
    Map action = {};
    return StoreConnector<MusicState, MusicState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            await state.musicInfo.getColor();
            await state.musicInfo.getLyric();

            NavigatorUtils.pushPage(
                context: context, targPage: MusicPlayPage());
          },
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: getSongAlbumPic(state.musicInfo.albumMid),
                  ),
                  backgroundColor: Colors.white10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.musicInfo.songName,
                            style: TextStyle(fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.musicInfo.singerName,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                StoreConnector<MusicState, VoidCallback>(
                  converter: (store) {
                    //action['type'] = MusicActions.next;
                    return () => store.dispatch(handler(action));
                  },
                  builder: (store, callback) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            action['type'] = MusicActions.pre;
                            callback();
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (state.state == "playing") {
                              action['type'] = MusicActions.pause;
                            } else if (state.state == "pause") {
                              // int result = await audioPlayer.resume();
                              action['type'] = MusicActions.play;
                            } else if (state.state == "stop") {
                              action['type'] = MusicActions.play;
                            }
                            callback();
                          },
                          icon: state.state != "playing"
                              ? Icon(Icons.play_arrow,
                                  size: 25, color: Colors.black)
                              : Icon(Icons.pause,
                                  size: 25, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: () {
                            action['type'] = MusicActions.next;
                            callback();
                          },
                          icon: Icon(Icons.skip_next,
                              size: 25, color: Colors.black),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          ),
        );
      },
    );
  }

  Widget getSongAlbumPic(String albumMid) {
    if (albumMid == "") {
      LogUtils.e("albumMid为空");
      return Image.network(
          'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
              '000LNpPn0efhTG' +
              '.jpg');
    } else {
      return Image.network(
          'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
              albumMid +
              '.jpg');
    }
  }

/*   Widget bottom() {
    return ListTile(
      title: new Text(MusicPlaying.songName),
      subtitle: new Text(MusicPlaying.singerName),
      dense: true,
      leading: CircleAvatar(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: getSongAlbumPic(),
        ),
        backgroundColor: Colors.white10,
      ),
    );
  } */
}
