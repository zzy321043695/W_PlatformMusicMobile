/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-23 10:52:20
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-07 15:59:25
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/local_file_utils.dart';
import 'package:music_learn/src/widgets/progress_bar.dart';
import 'package:music_learn/src/widgets/lyric_roll.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:redux/redux.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  _MusicPlayPageState createState() {
    return _MusicPlayPageState();
  }
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<MusicState, MusicState>(
      converter: (store) => store.state,
      builder: (context, state) {
        bool isFavorite = FavoriteMusicState.isFavoriteMusic(state.musicInfo);
        return Material(
          child: Stack(
            children: <Widget>[
              backGround(state.musicInfo.coverMainColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  albumPic(
                      state.musicInfo.coverMainColor, state.musicInfo.picUrl),
                  /*  Expanded(
                    child: LyricRoll(state.musicInfo.lyric, state.state),
                    // child: Container(),
                  ), */
                  Container(
                    // margin: EdgeInsets.only(left: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isFavorite
                            ? IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  FavoriteMusicState.removeFavoriteMusic(
                                      state.musicInfo);
                                  setState(() {});
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  FavoriteMusicState.addFavoriteMusic(
                                      state.musicInfo);
                                  setState(() {});
                                },
                              ),
                        IconButton(
                          icon: Icon(Icons.get_app),
                          onPressed: () {
                            LocalFileUtils.downloadMusic(
                                'url', state.musicInfo);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  /*  ProgressBar(
                    color: state.musicInfo.coverMainColor,
                    state: state.state,
                  ), */
                  musicController(state),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, size: 30, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget backGround(List<int> color) {
    //LogUtils.e("color");
    //print(color);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(
                //opacity：不透明度
                color[0],
                color[1],
                color[2],
                1),
            Colors.white
          ],
        ),
      ),
    );
  }

  Widget albumPic(List<int> color, String picUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.2,
          MediaQuery.of(context).size.width * 0.3, 0, 0),
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color.fromRGBO((color[0] / 5).round(),
                (color[1] / 5).round(), (color[2] / 5).round(), 0.3),
            blurRadius: MediaQuery.of(context).size.width * 0.3,
            spreadRadius: 5,
            offset: Offset(0, 0))
      ]),
      child: Hero(
        tag: 'songImage',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: picUrl,
            placeholder: (context, url) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget musicController(MusicState musicState) {
    Map action = {};

    return StoreConnector<MusicState, VoidCallback>(
      converter: (store) {
        //action['type'] = MusicActions.next;
        return () => store.dispatch(handler(action));
      },
      builder: (store, callback) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                action['type'] = MusicActions.pre;
                callback();
              },
              icon: Icon(Icons.skip_previous, size: 40, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                if (musicState.state == "playing") {
                  action['type'] = MusicActions.pause;
                } else if (musicState.state == "pause") {
                  action['type'] = MusicActions.play;
                } else if (musicState.state == "stop") {
                  action['type'] = MusicActions.play;
                }
                callback();
              },
              icon: musicState.state != "playing"
                  ? Icon(Icons.play_arrow, size: 40, color: Colors.black)
                  : Icon(Icons.pause, size: 40, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                action['type'] = MusicActions.next;
                callback();
              },
              icon: Icon(Icons.skip_next, size: 40, color: Colors.black),
            ),
          ],
        );
      },
    );
  }
}
