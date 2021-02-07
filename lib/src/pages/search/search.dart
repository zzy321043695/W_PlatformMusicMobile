/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-30 16:37:22
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-05 11:10:25
 */
import 'package:flutter/material.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/config/music_source.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/widgets/music_search_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "单曲",
    ),
    Tab(
      text: "歌单",
    ),
    Tab(
      text: "用户",
    ),
    Tab(
      text: "歌词",
    ),
    Tab(
      text: "专辑",
    ),
    Tab(
      text: "歌手",
    ),
    Tab(
      text: "mv",
    ),
  ];
  List _searchList;
  TabController _tabController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var val = MusicSource.source;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: MusicSource.source,
                  items: [
                    DropdownMenuItem(
                      child: Text('QQ'),
                      value: 'qq',
                    ),
                    DropdownMenuItem(
                      child: Text('咪咕'),
                      value: 'migu',
                    ),
                    DropdownMenuItem(
                      child: Text('酷我'),
                      value: 'kuwo',
                    ),
                    DropdownMenuItem(
                      child: Text('酷狗'),
                      value: 'kugou',
                    ),
                    DropdownMenuItem(
                      child: Text('网易'),
                      value: 'wangyi',
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      MusicSource.source = value;
                    });
                  }),
            ),
          ],
          title: TextField(
            controller: _textController,
            onSubmitted: (value) {
              //LogUtils.e("搜索结果");
              //print('$value');
              /* Net.qqSearch(key: value).then((v) {
                //print(v);
                setState(() {
                  _searchList = v.data['data']['song'];
                });
              }); */
              Net.searchSong(MusicSource.source, value, '').then((v) {
                setState(() {
                  _searchList = v;
                  print(MusicSource.source);
                  print(v);
                });
              });
            },
            cursorColor: Colors.black,
            cursorWidth: 1,
            cursorHeight: 25,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                  // style: BorderStyle.none, // 隐藏边框
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                  // style: BorderStyle.none, // 隐藏边框
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: TabBar(
              indicatorColor: Colors.black,
              labelPadding: EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              labelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(fontSize: 12),
              isScrollable: true,
              controller: _tabController,
              tabs: myTabs,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();

          return Center(
            child: tabView(label),
          );
        }).toList(),
      ),
      bottomNavigationBar: CustomBottomNavigationBarNotkey(),
    );
  }

  Widget tabView(String tabTitle) {
    return MusicListWidget(_searchList, MusicSource.source);
  }
}
