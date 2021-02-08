/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-08 09:36:55
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 14:09:47
 */
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';

import 'local_file_utils.dart';

class FavoriteListUtils {
  static String prefix = 'favorite';
  static List<MusicInfo> musicList =
      LocalFileUtils.getLocalData(FavoriteListUtils.prefix);

  static void addMusic(MusicInfo m) {
    LocalFileUtils.addData(m, musicList, prefix);
  }

  static void removeMusic(MusicInfo m) {
    LocalFileUtils.removeData(m, musicList, prefix);
  }

  static bool isMusic(MusicInfo m) {
    return LocalFileUtils.isInList(m, musicList);
  }
}
