/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-24 20:16:09
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-19 23:38:05
 */
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';

class MusicController {
  static AudioPlayer audioPlayer = new AudioPlayer();
  static String status = "pause";
  static Duration duration;
  static Duration position;
  StreamSubscription playerCompleteSubscription;

  //参考 https://www.jianshu.com/p/de7ff8d5c7ac

  static init() {
    //监听歌曲时长
    MusicController.audioPlayer.onDurationChanged.listen((d) {
      MusicController.duration = d;
    });

    //播放中监听
    MusicController.audioPlayer.onAudioPositionChanged.listen((p) {
      MusicController.position = p;
    });

    //播放状态改变
    MusicController.audioPlayer.onPlayerStateChanged.listen((state) {});
  }
}
