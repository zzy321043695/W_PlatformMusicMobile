/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-24 15:49:09
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-23 17:16:07
 */
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:dio/dio.dart';
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
      this.songName,
      this.source,
      this.url});

  Future getColor() async {
    String u = 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
        this.albumMid +
        '.jpg';
    LogUtils.e("photoUrl");
    LogUtils.e(u);

    await getColorFromUrl(u).then((value) {
      this.coverMainColor = value;
      LogUtils.e("color");
      print(coverMainColor);
    }).catchError((e) {
      LogUtils.e("错误");
      print(e);
    });
  }

  Future getLyric() async {
    await Net.qqLyric(this.songMid).then((v) {
      String lyricStr = v.data['lyric'];
      // LogUtils.e("歌词");
      // LogUtils.e(lyricStr);
      this.lyric = formatLyric(lyricStr);
      // LogUtils.e("LyricMap");
      /* for (int i = 0; i < lyric.length - 1; i++) {
        LogUtils.e(lyric[i].lyric);
      } */
    });
  }

  Future getUrl() async {
    await Net.qqSongUrl(this.songMid, "320").then((v) {
      this.url = v.data['data']['url'][this.songMid];
    });
  }

  Future getCoverMainColor(String url) async {
    LogUtils.e("color");
    List<int> color = await getColorFromUrl(url);
    LogUtils.e("color");
    print(color);
    return color;
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
    LogUtils.e("收藏长度");
    print(songNameList.length);
    List<MusicInfo> result = [];
    for (int i = 0; i < songNameList.length; i++) {
      MusicInfo m = MusicInfo(
          songName: songNameList[i],
          songMid: songMidList[i],
          singerName: singerNameList[i],
          albumMid: albumMidList[i]);
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
      url:
          "https://isure.stream.qqmusic.qq.com/F000004bd0Av3rVEE3.flac?guid=658650575&vkey=345A5870B35FD4E06477AB22AC17AB47E200600A85C39B0DA4EC289588641C984506CB91A5D3721B1B1792BEEF4C8FAED25D37A85782E817&uin=1899&fromtag=66");
  List<MusicInfo> musicList = List<MusicInfo>();
  musicList.add(musicInfo);
  return MusicState(musicInfo, musicList, 0, "stop");
}

ThunkAction handler(action) {
  LogUtils.e("中间件");
  return (Store store) async {
    if (action['type'] == MusicActions.pause) {
      await MusicController.audioPlayer.pause();
      store.state.state = "pause";
      store.dispatch(action);
    } else if (action['type'] == MusicActions.play) {
      if (action['musicList'] == null) {
        await store.state.musicInfo.getColor();
        await store.state.musicInfo.getLyric();
        await store.state.musicInfo.getUrl();
        await MusicController.audioPlayer
            .play(store.state.musicInfo.url)
            .then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            LogUtils.e('播放成功');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            LogUtils.e('播放失败');
            store.state.state = "pause";
          }
        });
        store.dispatch(action);
      } else {
        await MusicController.audioPlayer.resume().then((value) {
          if (value == 1) {
            // success
            MusicController.status = "playing";
            LogUtils.e('播放成功');
            store.state.state = "playing";
          } else {
            MusicController.status = "pause";
            LogUtils.e('播放失败');
            store.state.state = "pause";
          }
        });
      }
      store.dispatch(action);
    } else if (action['type'] == MusicActions.newMusic) {
      await action['musicInfo'].getColor();
      await action['musicInfo'].getLyric();
      await action['musicInfo'].getUrl();
      LogUtils.e("开始播放");
      LogUtils.e(action['musicInfo'].url);
      print(action['musicInfo'].lyric);
      await MusicController.audioPlayer
          .play(action['musicInfo'].url)
          .then((value) {
        if (value == 1) {
          // success
          MusicController.status = "playing";
          LogUtils.e('play success');
          store.state.state = "playing";
        } else {
          MusicController.status = "pause";
          LogUtils.e('play failed');
          store.state.state = "pause";
        }
      });
      LogUtils.e("新歌");
      LogUtils.e(action['musicInfo'].songMid);
      store.dispatch(action);
    } else if (action['type'] == MusicActions.pre) {
      if (store.state.currentMusicIndex > 0) {
        MusicInfo music =
            store.state.musicList[store.state.currentMusicIndex - 1];
        await music.getColor();
        await music.getLyric();
        await music.getUrl();
        await MusicController.audioPlayer.play(music.url);
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
      LogUtils.e("下一首");
      if (store.state.currentMusicIndex < store.state.musicList.length - 1) {
        print(store.state.currentMusicIndex);
        print(store.state.musicList.length);

        MusicInfo music =
            store.state.musicList[store.state.currentMusicIndex + 1];
        await music.getColor();
        await music.getLyric();
        await music.getUrl();
        await MusicController.audioPlayer.play(music.url);
        store.state.musicInfo = music;
        store.state.currentMusicIndex++;
        store.state.state = "playing";
        store.dispatch(action);
      } else {
        await MusicController.audioPlayer.resume();
        action['state'] = "playing";
        store.dispatch(action);
      }
    }
  };
}

MusicState musicStateReducer(MusicState musicState, action) {
  LogUtils.e("reducerFunc");
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
