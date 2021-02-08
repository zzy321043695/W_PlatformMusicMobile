/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-07 15:22:54
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 14:09:25
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/pages/config/app_varies.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileUtils {
  ///当前进度进度百分比  当前进度/总进度 从0-1
  double currentProgress = 0.0;

  ///下载文件的网络路径
  String apkUrl = "";

  static List channelNames = [
    'songNameList',
    'songMidList',
    'singerNameList',
    'albumMidList',
    'hashList',
    'source',
    'picUrl',
    'localPath',
  ];

  ///使用dio 下载文件

  static downloadMusic(String url, MusicInfo musicInfo,
      {Function onComplete}) async {
    /// 申请写文件权限
    if (true) {
      ///手机储存目录
      String savePath = await getPhoneLocalPath();
      savePath += '/music_learn/';
      String fileName = musicInfo.songName +
          '-' +
          musicInfo.singerName +
          '-' +
          musicInfo.songMid +
          "(" +
          musicInfo.source +
          ").mp3";
      print("存储路径：" + "$savePath$fileName");

      if (musicInfo.url == null || musicInfo.url == '') {
        await musicInfo.getUrl();
        if (musicInfo.url == null || musicInfo.url == '') {
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
      }

      ///创建DIO
      Dio dio = new Dio();

      ///参数一 文件的网络储存URL
      ///参数二 下载的本地目录文件
      ///参数三 下载监听
      Response response = await dio
          .download(musicInfo.url, "$savePath$fileName",
              onReceiveProgress: (received, total) {
        if (total != -1) {
          ///当前下载的百分比例
          // print((received / total * 100).toStringAsFixed(0) + "%");
          if (total == received) {
            print("下载完成");
            musicInfo.localPath = "$savePath$fileName";
            onComplete();
          }
          // CircularProgressIndicator(value: currentProgress,) 进度 0-1
          // currentProgress = received / total;
        }
      });
      print(response.data);
    }
  }

  static Future<String> getPhoneLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static getLocalMusicList() async {
    String dir = await getPhoneLocalPath();
    print("路径：" + '$dir/music_learn/');

    AppVaries.savePath = '$dir/music_learn/';
    List localMusicList = [];
    Directory directory = new Directory('$dir/music_learn/');
    directory.listSync().forEach((file) {
      //file的类型为FileSystemEntity；
      localMusicList.add(file.path);
      print(file.path);
    });
    return localMusicList;
  }

  static List<MusicInfo> getLocalData(String prefix) {
    List<List<String>> dataList = [];
    for (int i = 0; i < channelNames.length; i++) {
      List<String> songNameList = LocalCacheLoader(prefix + channelNames[i])
          .all
          .map(
            (cache) => cache.value['1'],
          )
          .toList()
          .cast<String>();
      dataList.add(songNameList);
    }

    List<MusicInfo> result = [];
    for (int i = 0; i < dataList[0].length; i++) {
      MusicInfo m = MusicInfo(
        songName: dataList[0][i],
        songMid: dataList[1][i],
        singerName: dataList[2][i],
        albumMid: dataList[3][i],
        hash: dataList[4][i],
        source: dataList[5][i],
        picUrl: dataList[6][i],
        localPath: dataList[7][i],
      );
      result.add(m);
    }
    return result;
  }

  static saveToLocalData(String prefix, List<MusicInfo> musicList) {
    for (int i = 0; i < channelNames.length; i++) {
      LocalCacheLoader(prefix + channelNames[i]).clearAll();
    }
    for (int i = 0; i < musicList.length; i++) {
      LocalCacheLoader(prefix + 'songNameList').saveById(i.toString(), {
        '1': musicList[i].songName,
      });
      LocalCacheLoader(prefix + 'songMidList').saveById(i.toString(), {
        '1': musicList[i].songMid,
      });
      LocalCacheLoader(prefix + 'singerNameList').saveById(i.toString(), {
        '1': musicList[i].singerName,
      });
      LocalCacheLoader(prefix + 'albumMidList').saveById(i.toString(), {
        '1': musicList[i].albumMid,
      });
      LocalCacheLoader(prefix + 'hashList').saveById(i.toString(), {
        '1': musicList[i].hash,
      });
      LocalCacheLoader(prefix + 'source').saveById(i.toString(), {
        '1': musicList[i].source,
      });
      LocalCacheLoader(prefix + 'picUrl').saveById(i.toString(), {
        '1': musicList[i].picUrl,
      });
      LocalCacheLoader(prefix + 'localPath').saveById(i.toString(), {
        '1': musicList[i].localPath,
      });
    }
  }

  static addData(MusicInfo m, List<MusicInfo> localMusicList, String prefix) {
    bool alreadyExits = false;
    for (MusicInfo tem in localMusicList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        break;
      }
    }
    if (!alreadyExits) {
      localMusicList.add(m);
      saveToLocalData(prefix, localMusicList);
    }
  }

  static void removeData(
      MusicInfo m, List<MusicInfo> localMusicList, String prefix) {
    bool alreadyExits = false;
    for (MusicInfo tem in localMusicList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        localMusicList.remove(tem);
        break;
      }
    }
    if (alreadyExits) {
      saveToLocalData(prefix, localMusicList);
    }
  }

  static bool isInList(MusicInfo m, List<MusicInfo> localMusicList) {
    bool alreadyExits = false;
    for (MusicInfo tem in localMusicList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        break;
      }
    }
    return alreadyExits;
  }
}
