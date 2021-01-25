/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 15:31:17
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-25 11:57:24
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class Net {
  static String generateMd5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  static getRankLists(String source) async {
    try {
      Response response = await Dio().get(
        "http://iecoxe.top:3500/qq/top/",
      );
      LogUtils.e("热歌榜");
      print(response.data['detail']['data']['data']['song']);
      Map<String, dynamic> responseData = json.decode(response.toString());
      return response;
    } catch (e) {
      print(e);
    }
  }

  static getHttp() async {
    try {
      Response response = await Dio().get(
        "http://iecoxe.top:3500/qq/top/",
      );
      LogUtils.e("热歌榜");
      print(response.data['detail']['data']['data']['song']);
      Map<String, dynamic> responseData = json.decode(response.toString());
      return response;
    } catch (e) {
      print(e);
    }
  }

  static qqSongUrl(String mid, String br) async {
    try {
      Response response = await Dio().get(
        "http://iecoxe.top:3500/qq/song/url/?mid=${mid}&br=${br}",
      );
      if (response.data['data']['url'][mid] == null ||
          response.data['data']['url'][mid] == '') {
        LogUtils.e("将为最低品质");
        response = await Dio().get(
          "http://iecoxe.top:3500/qq/song/url/?mid=${mid}&br=128",
        );
      }
      LogUtils.e("单曲");
      print(response.data);
      return response;
    } catch (e) {
      print(e);
    }
  }

  static qqLyric(String mid) async {
    try {
      LogUtils.e("url");
      LogUtils.e("http://iecoxe.top:3500/qq/lyric/?mid=" + mid);
      Response response = await Dio().get(
        "http://iecoxe.top:3500/qq/lyric/?mid=" + mid,
      );
      /* LogUtils.e("歌词");
      print(response.data['lyric']); */

      return response;
    } catch (e) {
      print(e);
    }
  }

  static qqSearch({
    String key = "暗号",
    String limit = "30",
    String offset = "1",
    String type = "0", //取值意义 type: 0：单曲，2：歌单，3:用户 ,7：歌词，8：专辑，9：歌手，12：mv
    String albummid = "",
  }) async {
    try {
      LogUtils.e("url");
      // LogUtils.e("http://iecoxe.top:3500/qq/lyric/?mid=" + mid);
      Map<String, dynamic> jsonData = {
        "key": key,
        "limit": limit,
        "offset": offset,
        "type": type,
        "albummid": albummid,
      };
      Response response = await Dio().get(
        "http://iecoxe.top:3500//qq/search/",
        queryParameters: jsonData,
      );
      LogUtils.e("搜索");
      print(response.data['data']['song']);
      return response;
    } catch (e) {
      print(e);
    }
  }
}
