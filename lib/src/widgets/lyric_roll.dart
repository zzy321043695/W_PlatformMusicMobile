/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-30 13:39:19
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-12 14:40:21
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class LyricRoll extends StatefulWidget {
  List<Lyric> lyric = <Lyric>[];
  String state;
  LyricRoll(this.lyric, this.state);

  @override
  _LyricState createState() {
    return _LyricState();
  }
}

class _LyricState extends State<LyricRoll> {
  /*  String pre = "";
  String now = "";
  String next = ""; */
  List<String> ly = ["", "", ""];
  //int lyricIndex = 0;
  Timer timer;
  @override
  void initState() {
    //LogUtils.e("歌词组件");
    ////print(widget.lyric);
    super.initState();
    ly = lyricLocate(widget.lyric);
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        ly = lyricLocate(widget.lyric);
      });
    });
  }

  List<String> lyricLocate(List<Lyric> l) {
    List<String> lyricDisplay = ["", "", ""];
    if (l.length > 0) {
      if (widget.state == "stop") {
        lyricDisplay[0] = '';
        lyricDisplay[1] = '';
        lyricDisplay[2] = l[0].lyric;
        return lyricDisplay;
      } else {
        for (int i = 0; i < l.length; i++) {
          if (l[i].startTime < MusicController.position &&
              l[i].endTime > MusicController.position) {
            if (i == 0) {
              lyricDisplay[0] = "";
              lyricDisplay[1] = l[i].lyric;
              if (i + 1 <= l.length - 1) {
                lyricDisplay[2] = l[i + 1].lyric;
              } else {
                lyricDisplay[2] = '';
              }
            } else if (i == l.length - 1) {
              if (i - 1 >= 0) {
                lyricDisplay[0] = l[i - 1].lyric;
              } else {
                lyricDisplay[0] = '';
              }
              lyricDisplay[0] = l[i - 1].lyric;
              lyricDisplay[1] = l[i].lyric;
              lyricDisplay[2] = "";
            } else {
              lyricDisplay[0] = l[i - 1].lyric;
              lyricDisplay[1] = l[i].lyric;
              lyricDisplay[2] = l[i + 1].lyric;
            }
          } else if (l[i].startTime > MusicController.position && i == 0) {
            lyricDisplay[0] = '';
            lyricDisplay[1] = '';
            lyricDisplay[2] = l[0].lyric;
            break;
          } else if (l[i].startTime > MusicController.position && i != 0) {
            //LogUtils.e("歌词定位错误");
            break;
          }
        }
      }

      return lyricDisplay;
    }
    return lyricDisplay;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              ly[0],
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            ly[1],
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            ly[2],
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
