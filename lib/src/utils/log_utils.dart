/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-16 09:43:03
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-31 20:25:22
 */
class LogUtils {
  //是否输入日志标识
  static bool _isLog = true;
  static String _logFlag = "music_learn";

  static void init({bool islog = false, String logFlag = "Flutter-Ho"}) {
    _isLog = islog;
    _logFlag = logFlag;
  }

  static void e(String message) {
    if (_isLog) {
      print("$_logFlag | $message");
    }
  }
}
