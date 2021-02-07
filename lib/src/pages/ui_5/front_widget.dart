/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-02-05 11:34:22
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-02-07 10:50:00
 */
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_learn/src/pages/home/minePage.dart';
import 'package:music_learn/src/pages/home/rank_list.dart';
import 'package:music_learn/src/pages/music/custom_bottom_navigation_bar_notkey.dart';
import 'package:music_learn/src/pages/search/search.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class FrontWidget extends StatefulWidget {
  Function open;

  FrontWidget(this.open);

  @override
  _FrontWidgetState createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget>
    with TickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "我的",
    ),
    Tab(
      text: "排行榜",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: widget.open,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        controller: _tabController,
                        tabs: myTabs,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.search),
                      onPressed: () {
                        NavigatorUtils.pushPage(
                          context: context,
                          targPage: SearchPage(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 130,
                  child: TabBarView(
                    controller: _tabController,
                    children: myTabs.map((Tab tab) {
                      final String label = tab.text.toLowerCase();
                      return Center(
                        child: tabView(label),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 50,
          child: CustomBottomNavigationBarNotkey(),
        ),
      ],
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
