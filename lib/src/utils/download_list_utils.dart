/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-07 14:41:53
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-07 15:06:52
 */
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';

class downloadListUtils {
  static List<MusicInfo> favoriteList =
      downloadListUtils.getDownloadListFromLocal();
  // static LocalCacheLoader get loader => LocalCacheLoader('favorite');
  static List<MusicInfo> getDownloadListFromLocal() {
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
    var hashList = LocalCacheLoader('hashList')
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
        hash: hashList[i],
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
    LocalCacheLoader('hashList').clearAll();
    LocalCacheLoader('source').clearAll();
    LocalCacheLoader('picUrl').clearAll();
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
      LocalCacheLoader('hashList').saveById(i.toString(), {
        '1': musicList[i].hash,
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
