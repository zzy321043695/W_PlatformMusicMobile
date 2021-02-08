/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-08 09:44:29
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 09:50:03
 */
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'local_file_utils.dart';

class RecentListUtils {
  static String prefix = 'recent';
  static List<MusicInfo> musicList = LocalFileUtils.getLocalData(prefix);

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
