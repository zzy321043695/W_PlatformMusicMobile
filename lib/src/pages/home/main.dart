/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2020-12-22 10:34:18
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-05 12:18:12
 */

import 'package:flutter/material.dart';
import 'package:music_learn/src/pages/config/music_controller.dart';
import 'package:music_learn/src/pages/home/minePage.dart';
import 'package:music_learn/src/pages/home/rank_list.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/pages/search/search.dart';
import 'package:music_learn/src/pages/ui_5/home_page.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class MainPage extends StatefulWidget {
  final Function openMenu;
  MainPage(this.openMenu);
  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "我的",
    ),
    Tab(
      text: "排行榜",
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // MusicController.init();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() async {
    _tabController.dispose();
    //LogUtils.e("mainPage release");

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
    return Container(
      color: Colors.white,
    );
    Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white10,
            leading: IconButton(
              color: Colors.black,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: widget.openMenu,
            ),
            actions: [
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.search),
                onPressed: () {
                  NavigatorUtils.pushPage(
                    context: context,
                    targPage: SearchPage(),
                  );
                },
              ),
            ],
            title: Container(
              alignment: Alignment.center,
              child: TabBar(
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.all(22),
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
        ),
      ),
    );
  }

  Widget tabView(String tabTitle) {
    if (tabTitle == myTabs[0].text) {
      return MinePage();
    } else if (tabTitle == myTabs[1].text) {
      return RankListPage();
    }
  }
}
