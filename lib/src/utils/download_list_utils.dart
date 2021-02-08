/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-07 14:41:53
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-08 11:22:40
 */
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/local_file_utils.dart';

class DownloadListUtils {
  static String prefix = 'download';

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

  static String getLocalPath(MusicInfo m) {
    bool alreadyExits = false;
    String localPath = '';
    for (MusicInfo tem in musicList) {
      if (tem.songMid == m.songMid && tem.source == m.source) {
        alreadyExits = true;
        localPath = tem.localPath;
        break;
      }
    }
    return localPath;
  }
}
