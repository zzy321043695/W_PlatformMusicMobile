/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 09:49:37
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-05 11:01:26
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:music_learn/src/index_page.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/config/music_playing.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() async {
  final store = Store<MusicState>(
    musicStateReducer,
    initialState: musicStateInit(),
    middleware: [thunkMiddleware],
  );

  WidgetsFlutterBinding.ensureInitialized();
  LocalCacheSync.instance.setCachePath(
    await getTemporaryDirectory(),
    'music_data/',
  );
  runApp(
    RootApp(store: store),
  );
}

class RootApp extends StatefulWidget {
  final Store<MusicState> store;
  RootApp({Key key, this.store}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootAPPState(this.store);
  }
}

class _RootAPPState extends State {
  Store<MusicState> store;
  _RootAPPState(this.store);

  @override
  void initState() {
    super.initState();
    MusicController.init();
    MusicController.audioPlayer.onPlayerCompletion.listen((event) {
      Map action = {};
      action['type'] = MusicActions.next;
      this.store.dispatch(handler(action));
    });
  }

  @override
  void dispose() async {
    int result = await MusicController.audioPlayer.release();
    if (result == 1) {
      //LogUtils.e('release success');
    } else {
      //LogUtils.e('release failed');
    }
    MusicController.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<MusicState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IndexPage(),
      ),
    );
  }
}
