/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-24 15:49:09
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-05 11:06:01
 */
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

enum MusicActions {
  pause,
  play,
  newMusic,
  next,
  pre,
}

class MusicInfo {
  String songName = "";
  String songMid = "";
  String singerName = "";
  String albumMid = "";
  String picUrl = "";
  String hash = '';
  List<Lyric> lyric = <Lyric>[];
  String source = "qq";
  List<int> coverMainColor;
  String url;

  MusicInfo(
      {this.albumMid,
      this.coverMainColor,
      this.lyric,
      this.singerName,
      this.songMid,
      this.picUrl,
      this.hash,
      this.songName,
      this.source,
      this.url});

  Future wangyiGetPicUrl() async {
    if (this.source == 'wangyi') {
      await Net.getWangyiSongPicUrl(this.songMid).then((v) {
        this.picUrl = v;
      });
    }
  }

  Future getColor() async {
    await getColorFromUrl(this.picUrl).then((value) {
      this.coverMainColor = value;
      //LogUtils.e("color");
      //print(coverMainColor);
    }).catchError((e) {
      //LogUtils.e("错误");
      //print(e);
    });
  }

  Future getLyric() async {
    if (this.source != 'kuwo') {
      await Net.getLyric(this.source, this.songMid).then((v) {
        this.lyric = formatLyric(v);
        //LogUtils.e("歌词转换");
        //print(this.lyric);
      });
    } else {
      await Net.kuwoLyric(this.songMid).then((v) {
        List<Lyric> lyricList = [];
        int nextStartTime = 0;
        for (int i = 0; i < v.length; i++) {
          if (i == 0) {
            String startTime = v[i]['time'];
            double startTimeDouble = double.parse(startTime);
            int startMillisecondsInt = (startTimeDouble * 1000).round();

            String endTime = v[i + 1]['time'];
            double endTimeDouble = double.parse(endTime);
            int endMillisecondsInt = (endTimeDouble * 1000).round();
            Lyric lyricItem = Lyric(
              v[i]['lineLyric'],
              startTime: Duration(milliseconds: startMillisecondsInt),
              endTime: Duration(milliseconds: endMillisecondsInt),
            );
            lyricList.add(lyricItem);
            nextStartTime = endMillisecondsInt;
          } else if (i < v.length - 1) {
            String endTime = v[i + 1]['time'];
            double endTimeDouble = double.parse(endTime);
            int endMillisecondsInt = (endTimeDouble * 1000).round();
            Lyric lyricItem = Lyric(
              v[i]['lineLyric'],
              startTime: Duration(milliseconds: nextStartTime),
              endTime: Duration(milliseconds: endMillisecondsInt),
            );
            lyricList.add(lyricItem);
            nextStartTime = endMillisecondsInt;
          } else {
            int endMillisecondsInt = nextStartTime + 10000;
            Lyric lyricItem = Lyric(
              v[i]['lineLyric'],
              startTime: Duration(milliseconds: nextStartTime),
              endTime: Duration(milliseconds: endMillisecondsInt),
            );
            lyricList.add(lyricItem);
            nextStartTime = endMillisecondsInt;
          }
        }
        this.lyric = lyricList;
      });
      //LogUtils.e("酷我歌词转换");
      //print(this.lyric);
    }
  }

  Future getUrl() async {
    if (this.source != 'kugou') {
      await Net.getSongUrl(this.source, this.songMid, "flac").then((v) {
        this.url = v;
      });
    }
  }

  Future kugouGetSongurlAndLyricAndPicurl() async {
    if (this.source == 'kugou') {
      await Net.kugouSongurlAndLyricAndPicurl(this.songMid, this.hash)
          .then((v) {
        this.url = v['songUrl'];
        this.lyric = formatLyric(v['lyric']);
        this.picUrl = v['picUrl'];
      });
    }
  }

  List<Lyric> formatLyric(String lyricStr1) {
    RegExp reg = RegExp(r"^\[\d{2}");
    List<Lyric> result =
        lyricStr1.split("\n").where((r) => reg.hasMatch(r)).map((s) {
      String time = s.substring(0, s.indexOf(']'));
      String lyric = s.substring(s.indexOf(']') + 1);
      time = s.substring(1, time.length - 1);
      int hourSeparatorIndex = time.indexOf(":");
      int minuteSeparatorIndex = time.indexOf(".");
      return Lyric(
        lyric,
        startTime: Duration(
          minutes: int.parse(
            time.substring(0, hourSeparatorIndex),
          ),
          seconds: int.parse(
              time.substring(hourSeparatorIndex + 1, minuteSeparatorIndex)),
          milliseconds: int.parse(time.substring(minuteSeparatorIndex + 1)),
        ),
      );
    }).toList();

    for (int i = 0; i < result.length - 1; i++) {
      result[i].endTime = result[i + 1].startTime;
    }
    result[result.length - 1].endTime = Duration(hours: 1);
    return result;
  }
}

class FavoriteMusicState {
  static List<MusicInfo> favoriteList =
      FavoriteMusicState.getFavoriteListFromLocal();

  // static LocalCacheLoader get loader => LocalCacheLoader('favorite');

  static List<MusicInfo> getFavoriteListFromLocal() {
    var songNameList = LocalCacheLoader('songNameList')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    var songMidList = LocalCacheLoader('songMidList')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    var singerNameList = LocalCacheLoader('singerNameList')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    var albumMidList = LocalCacheLoader('albumMidList')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    var sourceList = LocalCacheLoader('source')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    var picUrlList = LocalCacheLoader('picUrl')
        .all
        .map(
          (cache) => cache.value['1'],
        )
        .toList();
    //LogUtils.e("收藏长度");
    //print(songNameList.length);
    List<MusicInfo> result = [];
    for (int i = 0; i < songNameList.length; i++) {
      MusicInfo m = MusicInfo(
        songName: songNameList[i],
        songMid: songMidList[i],
        singerName: singerNameList[i],
        albumMid: albumMidList[i],
        picUrl: picUrlList[i],
        source: sourceList[i],
      );
      result.add(m);
    }
    return result;
  }

  static void saveFavoriteListToLocal(List<MusicInfo> musicList) {
    LocalCacheLoader('songNameList').clearAll();
    LocalCacheLoader('songMidList').clearAll();
    LocalCacheLoader('singerNameList').clearAll();
    LocalCacheLoader('albumMidList').clearAll();
    for (int i = 0; i < musicList.length; i++) {
      LocalCacheLoader('songNameList').saveById(i.toString(), {
        '1': musicList[i].songName,
      });
      LocalCacheLoader('songMidList').saveById(i.toString(), {
        '1': musicList[i].songMid,
      });
      LocalCacheLoader('singerNameList').saveById(i.toString(), {
        '1': musicList[i].singerName,
      });
      LocalCacheLoader('albumMidList').saveById(i.toString(), {
        '1': musicList[i].albumMid,
      });
      LocalCacheLoader('source').saveById(i.toString(), {
        '1': musicList[i].source,
      });
      LocalCacheLoader('picUrl').saveById(i.toString(), {
        '1': musicList[i].picUrl,
      });
    }
  }

  static void addFavoriteMusic(MusicInfo m) {
    bool alreadyExits = false;
    // List<String> localData = [];
    Map localData = {};
    for (MusicInfo tem in FavoriteMusicState.favoriteList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        break;
      }
    }
    if (!alreadyExits) {
      FavoriteMusicState.favoriteList.add(m);
      FavoriteMusicState.saveFavoriteListToLocal(
          FavoriteMusicState.favoriteList);
    }
  }

  static void removeFavoriteMusic(MusicInfo m) {
    bool alreadyExits = false;
    Map localData = {};
    for (MusicInfo tem in FavoriteMusicState.favoriteList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        FavoriteMusicState.favoriteList.remove(tem);
        break;
      }
    }
    if (alreadyExits) {
      FavoriteMusicState.saveFavoriteListToLocal(
          FavoriteMusicState.favoriteList);
    }
  }

  static bool isFavoriteMusic(MusicInfo m) {
    bool alreadyExits = false;

    for (MusicInfo tem in FavoriteMusicState.favoriteList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        break;
      }
    }
    return alreadyExits;
  }
}

class MusicState {
  MusicInfo musicInfo;
  get musicInfoGet => musicInfo;
  List<MusicInfo> musicList = <MusicInfo>[];
  int currentMusicIndex = 0;
  String state = "pause";
  MusicState(
      this.musicInfo, this.musicList, this.currentMusicIndex, this.state);
  MusicState.empety() : this(MusicInfo(), <MusicInfo>[], 0, "stop");
}

MusicState musicStateInit() {
  MusicInfo musicInfo = new MusicInfo(
      songMid: "004bd0Av3rVEE3",
      singerName: "程响",
      songName: "四季予你",
      source: "qq",
      albumMid: "00431aJU0XFrgv",
      picUrl:
          'https://y.gtimg.cn/music/photo_new/T002R300x300M00000431aJU0XFrgv.jpg',
      url:
          "https://isure.stream.qqmusic.qq.com/F000004bd0Av3rVEE3.flac?guid=658650575&vkey=345A5870B35FD4E06477AB22AC17AB47E200600A85C39B0DA4EC289588641C984506CB91A5D3721B1B1792BEEF4C8FAED25D37A85782E817&uin=1899&fromtag=66");

  musicInfo.coverMainColor = [30, 98, 141];
  musicInfo.getColor();
  musicInfo.getLyric();
  musicInfo.getUrl();

  List<MusicInfo> musicList = List<MusicInfo>();
  musicList.add(musicInfo);
  return MusicState(musicInfo, musicList, 0, "stop");
}

ThunkAction handler(action) {
  //LogUtils.e("中间件");
  return (Store store) async {
    if (action['type'] == MusicActions.pause) {
      await MusicController.audioPlayer.pause();
      store.state.state = "pause";
      store.dispatch(action);
    } else if (action['type'] == MusicActions.play) {
      if (action['musicList'] == null) {
        await store.state.musicInfo.wangyiGetPicUrl();
        await store.state.musicInfo.getColor();
        await store.state.musicInfo.getLyric();
        await store.state.musicInfo.getUrl();
        if (store.state.musicInfo.url == '' ||
            store.state.musicInfo.url == null) {
          Fluttertoast.showToast(
              msg: "无该歌曲资源",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }
        await MusicController.audioPlayer
            .play(store.state.musicInfo.url)
            .then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            //LogUtils.e('播放成功');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            //LogUtils.e('播放失败');
            store.state.state = "pause";
          }
        });
        store.dispatch(action);
      } else {
        await MusicController.audioPlayer.resume().then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            //LogUtils.e('播放成功');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            //LogUtils.e('播放失败');
            store.state.state = "pause";
          }
        });
      }
      store.dispatch(action);
    } else if (action['type'] == MusicActions.newMusic) {
      LogUtils.e('音乐源');
      MusicInfo m = action['musicInfo'];
      LogUtils.e(m.source);
      LogUtils.e(m.picUrl);
      LogUtils.e(m.songMid);
      print(action['musicInfo']);
      if (action['musicInfo'].source != 'kugou') {
        await action['musicInfo'].wangyiGetPicUrl();
        await action['musicInfo'].getColor();
        await action['musicInfo'].getLyric();
        await action['musicInfo'].getUrl();
        //LogUtils.e("开始播放");
        //LogUtils.e(action['musicInfo'].url);
        //print(action['musicInfo'].lyric);
        if (action['musicInfo'].url == '' || action['musicInfo'].url == null) {
          Fluttertoast.showToast(
              msg: "无该歌曲资源",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }
        LogUtils.e(action['musicInfo'].url);
        await MusicController.audioPlayer
            .play(action['musicInfo'].url)
            .then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            //LogUtils.e('play success');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            //LogUtils.e('play failed');
            store.state.state = "pause";
          }
        });
      } else {
        await action['musicInfo'].kugouGetSongurlAndLyricAndPicurl();
        await action['musicInfo'].getColor();
        //LogUtils.e("开始播放");
        //LogUtils.e(action['musicInfo'].url);
        //print(action['musicInfo'].lyric);
        if (action['musicInfo'].url == '' || action['musicInfo'].url == null) {
          Fluttertoast.showToast(
              msg: "无该歌曲资源",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }
        await MusicController.audioPlayer
            .play(action['musicInfo'].url)
            .then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            //LogUtils.e('play success');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            //LogUtils.e('play failed');
            store.state.state = "pause";
          }
        });
      }

      //LogUtils.e("新歌");
      //LogUtils.e(action['musicInfo'].songMid);
      store.dispatch(action);
    } else if (action['type'] == MusicActions.pre) {
      if (store.state.currentMusicIndex > 0) {
        MusicInfo music =
            store.state.musicList[store.state.currentMusicIndex - 1];
        if (music.source != 'kugou') {
          await music.wangyiGetPicUrl();
          await music.getColor();
          await music.getLyric();
          await music.getUrl();
          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        } else {
          await music.kugouGetSongurlAndLyricAndPicurl();
          await music.getColor();
          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        }

        store.state.musicInfo = music;
        store.state.currentMusicIndex--;
        store.state.state = "playing";
        store.dispatch(action);
      } else {
        await MusicController.audioPlayer.resume();
        action['state'] = "playing";
        store.dispatch(action);
      }
    } else if (action['type'] == MusicActions.next) {
      // if(action['type'] == MusicActions.next)
      //LogUtils.e("下一首");
      if (store.state.currentMusicIndex < store.state.musicList.length - 1) {
        //print(store.state.currentMusicIndex);
        //print(store.state.musicList.length);

        MusicInfo music =
            store.state.musicList[store.state.currentMusicIndex + 1];
        if (music.source != 'kugou') {
          await music.wangyiGetPicUrl();
          await music.getUrl();
          await music.getLyric();
          await music.getColor();

          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        } else {
          await music.kugouGetSongurlAndLyricAndPicurl();
          await music.getColor();

          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        }

        store.state.musicInfo = music;
        store.state.currentMusicIndex++;
        store.state.state = "playing";
        store.dispatch(action);
      } else {
        MusicInfo music = store.state.musicList[0];
        if (music.source != 'kugou') {
          await music.wangyiGetPicUrl();
          await music.getUrl();
          await music.getLyric();
          await music.getColor();

          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        } else {
          await music.kugouGetSongurlAndLyricAndPicurl();
          await music.getColor();

          if (music.url == '' || music.url == null) {
            Fluttertoast.showToast(
                msg: "无该歌曲资源",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          await MusicController.audioPlayer.play(music.url);
        }

        store.state.musicInfo = music;
        store.state.currentMusicIndex = 0;
        store.state.state = "playing";
        store.dispatch(action);
        /* await MusicController.audioPlayer.resume();
        action['state'] = "playing";
        store.dispatch(action); */
      }
    }
  };
}

MusicState musicStateReducer(MusicState musicState, action) {
  //LogUtils.e("reducerFunc");
  if (action['type'] == MusicActions.pause) {
    return MusicState(musicState.musicInfo, musicState.musicList,
        musicState.currentMusicIndex, "pause");
  } else if (action['type'] == MusicActions.play) {
    return MusicState(musicState.musicInfo, musicState.musicList,
        musicState.currentMusicIndex, musicState.state);
  } else if (action['type'] == MusicActions.newMusic) {
    return MusicState(action['musicInfo'], action['musicList'],
        action['currentMusicIndex'], musicState.state);
  } else if (action['type'] == MusicActions.pre) {
    return MusicState(musicState.musicInfo, musicState.musicList,
        musicState.currentMusicIndex, "playing");
  } else if (action['type'] == MusicActions.next) {
    // if(action['type'] == MusicActions.next)

    return MusicState(musicState.musicInfo, musicState.musicList,
        musicState.currentMusicIndex, "playing");
  } else {
    // MusicController.audioPlayer.resume();
    return MusicState(musicState.musicInfo, musicState.musicList,
        musicState.currentMusicIndex, "playing");
  }
}

class Lyric {
  String lyric;
  Duration startTime;
  Duration endTime;

  Lyric(this.lyric, {this.startTime, this.endTime});

  @override
  String toString() {
    return 'Lyric{lyric: $lyric, startTime: $startTime, endTime: $endTime}';
  }
}
