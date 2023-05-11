import 'package:app/widgets/game_result.dart';
import 'package:app/screens/mypage/game_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GameDetail extends StatefulWidget {
  const GameDetail({Key? key}) : super(key: key);

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  int _seletedItem = 0;
  var _pages = [GameDetailView1(), GameDetailView2()];
  var _pageController = PageController();
  Map<String, dynamic>? gameData;
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
    // GET 요청 보내기
    _fetchGameData();
  }

  Future<void> _fetchGameData() async {
    try {
      Response response =
      await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/member/1');
      setState(() {
        List<dynamic> responseData = response.data;
        gameData = responseData.length > 0 ? responseData[0] as Map<String, dynamic> : null;
      });
      print('데이터 내놔 ${gameData}');

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: PageView(
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _seletedItem = index;
            });
          },
          controller: _pageController,
        ),
      ),
    );
  }
}
