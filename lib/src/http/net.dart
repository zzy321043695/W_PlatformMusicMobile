/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 15:31:17
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-31 21:11:36
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_learn/src/utils/log_utils.dart';

class Net {
  // static MusicInfo musicInfo = MusicInfo();
  static String wangyiUrl = "http://iecoxe.top:3000";
  static String serverUrl = "http://iecoxe.top:5000/v1";
  static String serverUrlv1 = "http://iecoxe.top:5000/v1";
  static String serverUrlold = "http://iecoxe.top:3500";
  static String songUrlv1 = "/qq/song/";
  static String qqAlbumPicUrl =
      'https://y.gtimg.cn/music/photo_new/T002R300x300M000';

  static String generateMd5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  ///[source]取值migu、qq、kuwo、kugou
  static getRankLists(String source) async {
    String url = Net.serverUrl + '/' + source + '/topCategory';
    String wangyiTopListsUrl = Net.wangyiUrl + '/toplist/';
    //LogUtils.e(url);
    Map result = {};
    List topListList = [];
    try {
      Response response = Response();
      if (source != 'wangyi') {
        response = await Dio().get(url);
      } else {
        response = await Dio().get(wangyiTopListsUrl);
      }

      switch (source) {
        case 'qq':
          List topCategory = response.data['topList']['data']['group'];
          for (int i = 0; i < topCategory.length; i++) {
            Map topListMap = {};
            List topList = [];
            for (int j = 0; j < topCategory[i]['toplist'].length; j++) {
              if (topCategory[i]['toplist'][j]['topId'] != 201) {
                Map topListItem = {};
                topListItem['id'] = topCategory[i]['toplist'][j]['topId'];
                topListItem['topName'] = topCategory[i]['toplist'][j]['title'];
                topList.add(topListItem);
              }
            }
            topListMap['class'] = topCategory[i]['groupName'];
            topListMap['list'] = topList;
            topListList.add(topListMap);
          }
          break;
        case 'migu':
          List topCategory = response.data['data']['topList'];
          for (int i = 0; i < topCategory.length; i++) {
            if (topCategory[i]['topId'] != 13) {
              Map topListItem = {};
              topListItem['id'] = topCategory[i]['topId'];
              topListItem['topName'] = topCategory[i]['topName'];
              topListList.add(topListItem);
            }
          }
          /*  //LogUtils.e("咪咕排行榜");
          //print(topListList); */
          break;
        case 'kuwo':
          List topCategory = response.data['data'];
          for (int i = 0; i < topCategory.length; i++) {
            Map topListMap = {};
            List topList = [];
            for (int j = 0; j < topCategory[i]['list'].length; j++) {
              Map topListItem = {};
              topListItem['id'] = topCategory[i]['list'][j]['sourceid'];
              topListItem['topName'] = topCategory[i]['list'][j]['name'];
              topList.add(topListItem);
            }
            topListMap['class'] = topCategory[i]['name'];
            topListMap['list'] = topList;
            topListList.add(topListMap);
          }
          break;
        case 'kugou':
          List topCategory = response.data['data']['info'];
          for (int i = 0; i < topCategory.length; i++) {
            if (topCategory[i]['rankid'] != 33911 &&
                topCategory[i]['rankid'] != 30946) {
              Map topListItem = {};
              topListItem['id'] = topCategory[i]['rankid'].toString();
              topListItem['topName'] = topCategory[i]['rankname'];
              if (topCategory[i]['album_img_9'] != null ||
                  topCategory[i]['album_img_9'] != '') {
                String picUrlRaw = topCategory[i]['album_img_9'];
                topListItem['picUrl'] = picUrlRaw.split(r'{size}/').join('');
              } else if (topCategory[i]['imgurl'] != null ||
                  topCategory[i]['imgurl'] != '') {
                String picUrlRaw = topCategory[i]['imgurl'];
                topListItem['picUrl'] = picUrlRaw.split(r'{size}/').join('');
              } else if (topCategory[i]['bannerurl'] != null ||
                  topCategory[i]['bannerurl'] != '') {
                String picUrlRaw = topCategory[i]['bannerurl'];
                topListItem['picUrl'] = picUrlRaw.split(r'{size}/').join('');
              } else if (topCategory[i]['banner_9'] != null ||
                  topCategory[i]['banner_9'] != '') {
                String picUrlRaw = topCategory[i]['banner_9'];
                topListItem['picUrl'] = picUrlRaw.split(r'{size}/').join('');
              } else if (topCategory[i]['banner7url'] != null ||
                  topCategory[i]['banner7url'] != '') {
                String picUrlRaw = topCategory[i]['banner7url'];
                topListItem['picUrl'] = picUrlRaw.split(r'{size}/').join('');
              }
              topListList.add(topListItem);
            }
          }
          break;
        case 'wangyi':
          List topCategory = response.data['list'];
          for (int i = 0; i < topCategory.length; i++) {
            if (topCategory[i]['id'] != 5453912201 &&
                topCategory[i]['id'] != 71385702 &&
                topCategory[i]['id'] != 71384707 &&
                topCategory[i]['id'] != 1978921795 &&
                topCategory[i]['id'] != 745956260 &&
                topCategory[i]['id'] != 180106 &&
                topCategory[i]['id'] != 60131 &&
                topCategory[i]['id'] != 2809513713 &&
                topCategory[i]['id'] != 21845217 &&
                topCategory[i]['id'] != 27135204 &&
                topCategory[i]['id'] != 3001835560 &&
                topCategory[i]['id'] != 3812895 &&
                topCategory[i]['id'] != 11641012 &&
                topCategory[i]['id'] != 3001795926 &&
                topCategory[i]['id'] != 5338990334 &&
                topCategory[i]['id'] != 3112516681 &&
                topCategory[i]['id'] != 5059644681 &&
                topCategory[i]['id'] != 5059661515 &&
                topCategory[i]['id'] != 5059633707 &&
                topCategory[i]['id'] != 3001890046 &&
                topCategory[i]['id'] != 5059642708) {
              Map topListItem = {};
              topListItem['id'] = topCategory[i]['id'].toString();
              topListItem['topName'] = topCategory[i]['name'];
              topListItem['picUrl'] = topCategory[i]['coverImgUrl'];
              topListList.add(topListItem);
            }
          }
          /* //LogUtils.e("咪咕排行榜");
          //print(topListList); */
          break;
      }
      return topListList;
    } catch (e) {
      //print(e);
    }
  }

  static getRankList({
    @required String source,
    @required String topId,
    String rankName,
  }) async {
    Map result = {};
    List songlist = [];
    int listLength = 0;

    try {
      String url = Net.serverUrl + '/' + source + "/top/?topId=" + topId;
      String wangyiTopListUrl = wangyiUrl + '/top/list?id=' + topId;
      //LogUtils.e("榜单url：" + url);
      Response response = Response();
      if (source != 'wangyi') {
        response = await Dio().get(url);
      } else {
        response = await Dio().get(wangyiTopListUrl);
      }
      // //LogUtils.e("热歌榜");
      // //print(response.data['detail']['data']['data']['song']);
      // Map<String, dynamic> responseData = json.decode(response.toString());
      switch (source) {
        case 'qq':
          if (topId != '201') {
            result['topName'] =
                response.data['detail']['data']['data']['title'];
            //LogUtils.e(source + "榜单");
            // //print(response.data['detail']['data']['songInfoList']);
            List musicList = response.data['detail']['data']['songInfoList'];
            listLength = musicList.length;
            result['length'] = listLength;
            for (int i = 0; i < listLength; i++) {
              Map songItem = {};
              songItem['songName'] = musicList[i]['title'];
              songItem['songMid'] = musicList[i]['mid'];
              songItem['albumMid'] = musicList[i]['album']['mid'];
              songItem['singerName'] = musicList[i]['singer'][0]['name'];
              songItem['albumPicUrl'] =
                  Net.qqAlbumPicUrl + musicList[i]['album']['mid'] + '.jpg';
              // //print(songItem);
              songlist.add(songItem);
            }
            result['songlist'] = songlist;
          } else {
            //mv榜单
            result['topName'] =
                response.data['detail']['data']['data']['title'];
            //LogUtils.e("qq榜单");
            List musicList = response.data['detail']['data']['data']['song'];
            listLength = musicList.length;
            result['length'] = listLength;
            for (int i = 0; i < listLength; i++) {
              Map songItem = {};
              songItem['songName'] = musicList[i]['title'];
              songItem['songMid'] = musicList[i]['mid'];
              songItem['albumMid'] = musicList[i]['album']['mid'];
              songItem['singerName'] = musicList[i]['singer'][0]['name'];
              songItem['albumPicUrl'] =
                  Net.qqAlbumPicUrl + musicList[i]['album']['mid'] + '.jpg';
              songlist.add(songItem);
            }
            result['songlist'] = songlist;
          }
          break;
        case 'migu':
          result['topName'] = response.data['name'];
          listLength = response.data['songs']['items'].length;
          result['length'] = listLength;
          for (int i = 0; i < listLength; i++) {
            try {
              Map songItem = {};
              songItem['songName'] = response.data['songs']['items'][i]['name'];
              songItem['songMid'] =
                  response.data['songs']['items'][i]['copyrightId'];
              songItem['albumMid'] = ''
                  /* response.data['songs']['items'][i]['album']['albumId'] */;
              if (response.data['songs']['items'][i]['singers'] == null) {
                //LogUtils.e(i.toString());
                songItem['singerName'] = "未知"
                    /* response.data['songs']['items'][i]['singers'][0]['name'] */;
              } else {
                songItem['singerName'] =
                    response.data['songs']['items'][i]['singers'][0]['name'];
              }
              if (response.data['songs']['items'][i]['mediumPic'] == null) {
                songItem['albumPicUrl'] =
                    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190517%2F446d32b0ed344c58b5d1a853e8ec3418.jpeg&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614428130&t=b04596f839c4d059c533459d42448541';
              } else {
                songItem['albumPicUrl'] =
                    'http:' + response.data['songs']['items'][i]['mediumPic'];
              }
              songlist.add(songItem);
            } catch (e) {
              //LogUtils.e("错误发生在：" + i.toString());
              //print(e);
            }
          }

          result['songlist'] = songlist;
          if (topId == '13') {
            //print('aaabbb');
            //print({'aaa': result});
          }
          break;
        case 'kuwo':
          List musicList = response.data['data']['musicList'];
          result['topName'] = rankName;
          result['pic'] = response.data['data']['img'];
          listLength = musicList.length;
          result['length'] = listLength;
          for (int i = 0; i < listLength; i++) {
            Map songItem = {};
            songItem['songName'] = musicList[i]['name'];
            songItem['songMid'] = musicList[i]['rid'].toString();
            songItem['albumMid'] = musicList[i]['albumid'].toString();
            songItem['singerName'] = musicList[i]['artist'];
            songItem['albumPicUrl'] = musicList[i]['albumpic'];
            songlist.add(songItem);
          }
          result['songlist'] = songlist;
          break;
        case 'kugou':
          List musicList = response.data['data'];
          result['topName'] = rankName;
          // result['pic'] = response.data['data']['img'];
          listLength = musicList.length;
          result['length'] = listLength;
          for (int i = 0; i < listLength; i++) {
            Map songItem = {};
            songItem['songName'] = musicList[i]['songname'];
            songItem['songMid'] = musicList[i]['album_id'].toString();
            songItem['albumMid'] = musicList[i]['album_audio_id'].toString();
            songItem['singerName'] = musicList[i]['singername'];
            if (musicList[i]['hash'] != 0 || musicList[i]['hash'] != null) {
              songItem['hash'] = musicList[i]['hash'];
            } else if (musicList[i]['hash_320'] != 0 ||
                musicList[i]['hash_320'] != null) {
              songItem['hash'] = musicList[i]['hash_320'];
            } else if (musicList[i]['hash_ape'] != 0 ||
                musicList[i]['hash_ape'] != null) {
              songItem['hash'] = musicList[i]['hash_ape'];
            } else if (musicList[i]['hash_flac'] != 0 ||
                musicList[i]['hash_flac'] != null) {
              songItem['hash'] = musicList[i]['hash_flac'];
            } else {}
            songlist.add(songItem);
          }
          result['songlist'] = songlist;
          break;
        case 'wangyi':
          List musicList = response.data['playlist']['tracks'];
          result['topName'] = response.data['playlist']['name'];
          result['pic'] = response.data['playlist']['coverImgUrl'];
          listLength = musicList.length;
          result['length'] = listLength;
          for (int i = 0; i < listLength; i++) {
            try {
              Map songItem = {};
              songItem['songName'] = musicList[i]['name'];
              songItem['songMid'] = musicList[i]['id'].toString();
              if (musicList[i]['al'] != null || musicList[i]['al'] != '') {
                songItem['albumMid'] = musicList[i]['al']['id'].toString();
                songItem['albumPicUrl'] = musicList[i]['al']['picUrl'];
              }
              if (musicList[i]['ar'] != null || musicList[i]['ar'] != '') {
                songItem['singerName'] = musicList[i]['ar'][0]['name'];
              }
              songlist.add(songItem);
            } catch (e) {
              LogUtils.e('出问题：' + i.toString());
              print(e);
            }
          }
          result['songlist'] = songlist;
          // LogUtils.e('排行榜');
          // print(songlist);
          break;
      }

      return result;
    } catch (e) {
      LogUtils.e('错误topId：' + topId);
      //print(e);
    }
  }

  static getSongUrl(String source, String mid, String br) async {
    String url = '';
    LogUtils.e(source);
    switch (source) {
      case 'qq':
        url = await qqSongUrlV1(mid, br);
        break;
      case 'migu':
        url = await miguSongUrl(mid, br);
        break;
      case 'kuwo':
        url = await kuwoSongUrl(mid, br);
        break;
      case 'wangyi':
        // LogUtils.e('网易');
        url = await wangyiSongUrl(mid, '320000');
        break;
    }
    return url;
  }

  static getLyric(String source, String mid) async {
    String lyric = '';
    switch (source) {
      case 'qq':
        lyric = await qqLyric(mid);
        break;
      case 'migu':
        lyric = await miguLyric(mid);
        break;
      case 'wangyi':
        lyric = await wangyiLyric(mid);
        break;
      /* case 'kuwo':
        lyric = await kuwoLyric(mid);
        break; */
    }
    return lyric;
  }

  static miguSongUrl(String mid, String br) async {
    try {
      //LogUtils.e("咪咕单曲");
      String url = Net.serverUrlv1 + '/migu/' + "song?cid=${mid}&br=2";
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      String songUrl = 'https:' + response.data['data']['playUrl'];
      //LogUtils.e(songUrl);
      return songUrl;
    } catch (e) {
      //print(e);
    }
  }

  static miguLyric(String mid) async {
    try {
      //LogUtils.e("咪咕歌词");
      String url = Net.serverUrl + "/migu/lyric/?cid=" + mid;
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      String lyric = response.data['lyric'];
      return lyric;
    } catch (e) {
      //print(e);
    }
  }

  static qqSongUrlV1(String mid, String br) async {
    try {
      //LogUtils.e(Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=${br}");
      Response response = await Dio().get(
        Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=${br}",
      );
      //LogUtils.e("单曲");
      //print(response.data);
      //print(response.data['data']['url'].runtimeType.toString());
      if (response.data['data']['url'] == null ||
          response.data['data']['url'] == '' ||
          response.data['data']['url'].runtimeType.toString() ==
              "_InternalLinkedHashMap<String, dynamic>") {
        //LogUtils.e("将为最低品质");
        //LogUtils.e(Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=128");
        response = await Dio().get(
          Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=128",
        );
        if (response.data['data']['url'] == null ||
            response.data['data']['url'] == '' ||
            response.data['data']['url'].runtimeType.toString() ==
                "_InternalLinkedHashMap<String, dynamic>") {
          //LogUtils.e(Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=flac");

          response = await Dio().get(
            Net.serverUrlv1 + songUrlv1 + "?mid=${mid}&br=flac",
          );
        }
      }
      //LogUtils.e("单曲");
      String songUrl = response.data['data']['url'];
      return songUrl;
    } catch (e) {
      //print(e);
    }
  }

  static qqLyric(String mid) async {
    try {
      String url = Net.serverUrl + "/qq/lyric/?mid=" + mid;
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      String lyric = response.data['lyric'];
      return lyric;
    } catch (e) {
      //print(e);
    }
  }

  static kuwoSongUrl(String mid, String br) async {
    try {
      String url = Net.serverUrlv1 + '/kuwo/' + "song?rid=${mid}";
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      //LogUtils.e("单曲");
      //print(response.data);
      String songUrl = response.data['url'];
      return songUrl;
    } catch (e) {
      //print(e);
    }
  }

  static kuwoLyric(String mid) async {
    try {
      String url = Net.serverUrl + "/kuwo/lyric/?rid=" + mid;
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      /* */
      return response.data['data']['lrclist'];
    } catch (e) {
      //print(e);
    }
  }

  static kugouSongurlAndLyricAndPicurl(String aid, String hash) async {
    try {
      String url = Net.serverUrl + "/kugou/song/?aid=" + aid + '&hash=' + hash;
      //LogUtils.e(url);
      Response response = await Dio().get(url);
      /* */
      Map result = {};
      result['songUrl'] = response.data['data']['play_url'];
      result['picUrl'] = response.data['data']['img'];
      result['lyric'] = response.data['data']['lyrics'];
      if (response.data['data']['play_url'] == '' ||
          response.data['data']['play_url'] == null) {
        Fluttertoast.showToast(
            msg: "无该歌曲资源",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return result;
    } catch (e) {
      //print(e);
    }
  }

  static wangyiSongUrl(String mid, String br) async {
    try {
      String url = Net.wangyiUrl + '/song/url?id=' + mid + '&br=' + br;
      // LogUtils.e(url);
      Response response = await Dio().get(url);
      if (response.data['data'][0][url] == null ||
          response.data['data'][0][url] == '') {
        response = await Dio()
            .get(Net.wangyiUrl + '/song/url?id=' + mid + '&br=999000');
      }
      if (response.data['data'][0][url] == null ||
          response.data['data'][0][url] == '') {
        response = await Dio()
            .get(Net.wangyiUrl + '/song/url?id=' + mid + '&br=320000');
      }
      if (response.data['data'][0][url] == null ||
          response.data['data'][0][url] == '') {
        response = await Dio()
            .get(Net.wangyiUrl + '/song/url?id=' + mid + '&br=128000');
      }
      //LogUtils.e("单曲");
      //print(response.data);
      String songUrl = response.data['data'][0]['url'];
      songUrl = songUrl.replaceAll('http', 'https'); //http的地址无法播放
      return songUrl;
    } catch (e) {
      //print(e);
    }
  }

  static wangyiLyric(String mid) async {
    try {
      String url = Net.wangyiUrl + "/lyric?id=" + mid;
      // LogUtils.e(url);
      Response response = await Dio().get(url);
      /* */
      String lyric = response.data['lrc']['lyric'];
      // LogUtils.e('网易歌词');
      // LogUtils.e(lyric);
      return lyric;
    } catch (e) {
      //print(e);
    }
  }

  static getHttp() async {
    try {
      Response response = await Dio().get(
        Net.serverUrl + "/qq/top/",
      );
      //LogUtils.e("热歌榜");
      //print(response.data['detail']['data']['data']['song']);
      // Map<String, dynamic> responseData = json.decode(response.toString());
      return response;
    } catch (e) {
      //print(e);
    }
  }

  static qqSongUrl(String mid, String br) async {
    try {
      //LogUtils.e(Net.serverUrl + "/qq/song/url/?mid=${mid}&br=${br}");
      Response response = await Dio().get(
        Net.serverUrl + "/qq/song/url/?mid=${mid}&br=${br}",
      );
      //LogUtils.e("单曲");
      //print(response.data);
      //print(response.data['data']['url'].runtimeType.toString());
      if (response.data['data']['url'][mid] == null ||
          response.data['data']['url'][mid] == '' ||
          response.data['data']['url'].runtimeType.toString() ==
              "_InternalLinkedHashMap<String, dynamic>") {
        //LogUtils.e("将为最低品质");
        //LogUtils.e(Net.serverUrl + "/qq/song/url/?mid=${mid}&br=128");
        response = await Dio().get(
          Net.serverUrl + "/qq/song/url/?mid=${mid}&br=128",
        );
        if (response.data['data']['url'][mid] == null ||
            response.data['data']['url'][mid] == '' ||
            response.data['data']['url'].runtimeType.toString() ==
                "_InternalLinkedHashMap<String, dynamic>") {
          //LogUtils.e(Net.serverUrl + "/qq/song/url/?mid=${mid}&br=flac");

          response = await Dio().get(
            Net.serverUrl + "/qq/song/url/?mid=${mid}&br=flac",
          );
        }
      }
      //LogUtils.e("单曲");
      //print(response.data);
      return response;
    } catch (e) {
      //print(e);
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
      //LogUtils.e("url");
      // //LogUtils.e("http://iecoxe.top:3500/qq/lyric/?mid=" + mid);
      Map<String, dynamic> jsonData = {
        "key": key,
        "limit": limit,
        "offset": offset,
        "type": type,
        "albummid": albummid,
      };
      Response response = await Dio().get(
        Net.serverUrl + "/qq/search/",
        queryParameters: jsonData,
      );
      //LogUtils.e("搜索");
      //print(response.data['data']['song']);
      return response;
    } catch (e) {
      //print(e);
    }
  }
}
