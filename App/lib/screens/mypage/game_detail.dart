import 'package:app/screens/mypage/game_detail_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameDetail extends StatefulWidget {
  final int gameId;
  final int memberId;
  final String start;
  final String end;

  const GameDetail({
    required this.gameId,
    required this.memberId,
    required this.start,
    required this.end,
    Key? key}) : super(key: key);

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  List<Widget> _pages = [];
  var pagesLength;
  final _pageController = PageController();
  var test;

  // 마이페이지 게임상세조회 요청
  void getGameDetail() async {
    var dio = Dio();
      try {
        var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/area/member/${widget.memberId}/${widget.gameId}');

        List<dynamic> gamedata = response.data;
        List<List<Map<String, dynamic>>> groupedAreaLists = [];
        Map<String, List<Map<String, dynamic>>> tempMap = {};

        for (var area in gamedata) {
          String areaDate = area['areaDate'];
          DateTime dateTime = DateFormat('yyyy-MM-dd').parse(areaDate);
          String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

          if (!tempMap.containsKey(formattedDate)) {
            tempMap[formattedDate] = [];
          }

          tempMap[formattedDate]!.add(area);
        }

        groupedAreaLists = tempMap.values.toList();

        setState(() {
          test = response.data;
          _pages = List.generate(
            groupedAreaLists.length,
                (index) => GameDetailView1(
                gamedata: groupedAreaLists[index],
                memberId: widget.memberId
            ),
          );
        });
      } catch (e) {
        print(e.toString());
      }
  }

  @override
  void initState() {
    getGameDetail();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image : DecorationImage(
              image : AssetImage('assets/images/mypage-bg.png'),
              fit : BoxFit.fitWidth,
              alignment: Alignment.topLeft,
              repeat: ImageRepeat.noRepeat
            )
          ),
          child: PageView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            children: _pages,
          ),
        )
      ),
    );
  }
}
