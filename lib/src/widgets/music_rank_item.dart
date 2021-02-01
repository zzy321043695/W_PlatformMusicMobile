/*
 * @Description: 
 * @Author: zhengzhenyu
 * @Date: 2021-01-28 08:53:50
 * @LastEditors: zhengzhenyu
 * @LastEditTime: 2021-01-30 23:42:54
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_learn/src/http/net.dart';
import 'package:music_learn/src/pages/music/music_list.dart';
import 'package:music_learn/src/utils/log_utils.dart';
import 'package:music_learn/src/utils/navigator_utils.dart';

class MusicRankItem extends StatefulWidget {
  final String topId;
  final String source;
  final String rankName;
  MusicRankItem(
      {@required this.topId, @required this.source, @required this.rankName});
  @override
  _MusicRankItemState createState() => _MusicRankItemState();
}

class _MusicRankItemState extends State<MusicRankItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();

    double height = 105;
    return FutureBuilder(
      future: Net.getRankList(
          topId: widget.topId,
          source: widget.source,
          rankName: widget.rankName),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            //LogUtils.e("数据");
            //print(snapshot.data);
            return InkWell(
              onTap: () {
                NavigatorUtils.pushPage(
                  context: context,
                  targPage: MusicListPage(
                    source: widget.source,
                    topName: widget.rankName,
                    musicList: snapshot.data['songlist'],
                  ),
                );
              },
              child: Column(
                children: [
                  rankListItem(height, snapshot.data), //热歌榜
                ],
              ),
            );
          }
        } else {
          // 请求未结束，显示loading
          return Container(
            height: height,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget rankListItem(double height, dynamic rankList) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 13,
        left: 1,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        // color: Colors.red,
        height: height,
        decoration: new BoxDecoration(
          /*  border:
              new Border.all(color: Color(0xFFFF0000), width: 0.5), // 边色与边宽度 */
          color: Colors.white, // 底色
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
          /*  borderRadius: new BorderRadius.vertical(
              top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小 */
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200,
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rankList['topName'] == null ? 'null' : rankList['topName'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "1.   " +
                        rankList['songlist'][0]['songName'] +
                        " - " +
                        rankList['songlist'][0]['singerName'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "2.   " +
                        rankList['songlist'][1]['songName'] +
                        " - " +
                        rankList['songlist'][1]['singerName'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "3.   " +
                        rankList['songlist'][2]['songName'] +
                        " - " +
                        rankList['songlist'][2]['singerName'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.horizontal(
                    right: Radius.elliptical(10, 10)),
                image: DecorationImage(
                    image: NetworkImage(rankList['songlist'][0]['albumPicUrl']),
                    fit: BoxFit.cover),
              ),
            ),
            /* CachedNetworkImage(
              imageUrl: 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' +
                  rankList[0]['albumMid'] +
                  '.jpg',
              height: 100,
              width: 100,
            ), */
          ],
        ),
      ),
    );
  }
}
