/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-30 11:49:57
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-12 15:04:41
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';

class ProgressBar extends StatefulWidget {
  List<int> color;
  String state;
  ProgressBar({this.color, this.state});
  @override
  _ProgressBarState createState() {
    return _ProgressBarState();
  }
}

class _ProgressBarState extends State<ProgressBar> {
  Timer timer;
  double val = 0.0;
  double valJump = 0.0;
  bool isJusting = false; //用户是否在控制进度条
  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        if (!isJusting && widget.state != "stop") {
          val = MusicController.position.inMilliseconds /
              MusicController.duration.inMilliseconds *
              500;
          val = val.floor().toDouble();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.state != "stop"
        ? Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Text(timeFromDuration(MusicController.position)),
                Expanded(
                  child: Slider(
                    value: val,
                    label: timeFromVal(
                        valJump, MusicController.duration.inSeconds),
                    activeColor: Color.fromRGBO(
                        (widget.color[0] / 5).round(),
                        (widget.color[1] / 5).round(),
                        (widget.color[2] / 5).round(),
                        0.3),
                    inactiveColor: Colors.black26,
                    onChangeStart: (double v) {
                      isJusting = true;
                    },
                    onChangeEnd: (double v) {
                      final Position =
                          v / 500 * MusicController.duration.inMilliseconds;
                      MusicController.audioPlayer
                          .seek(Duration(milliseconds: Position.round()));
                      isJusting = false;
                    },
                    onChanged: (double v) {
                      valJump = v;
                      val = v;
                    },
                    divisions: 500,
                    min: 0,
                    max: 501,
                  ),
                ),
                Text(timeFromDuration(MusicController.duration)),
              ],
            ),
          )
        : Container();
  }

  String timeFromDuration(Duration d) {
    int sec = d.inSeconds % 60;
    String secStr;
    int min = d.inMinutes;
    String minStr;
    if (sec < 10) {
      secStr = "0$sec";
    } else {
      secStr = "$sec";
    }
    if (min < 10) {
      minStr = "0$min";
    } else {
      minStr = "$min";
    }
    return minStr + ':' + secStr;
  }

  String timeFromVal(double d, int total) {
    double s = d / 500 * total;
    double s1 = s % 60;
    int sec = s1.floor();
    String secStr;
    double m = (s / 60);
    int min = m.floor();
    String minStr;
    if (sec < 10) {
      secStr = "0$sec";
    } else {
      secStr = "$sec";
    }
    if (min < 10) {
      minStr = "0$min";
    } else {
      minStr = "$min";
    }
    return minStr + ':' + secStr;
  }
}
