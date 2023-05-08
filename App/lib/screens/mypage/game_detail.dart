import 'package:app/widgets/game_result.dart';
import 'package:app/screens/mypage/game_detail_view.dart';
import 'package:flutter/material.dart';

class GameDetail extends StatefulWidget {
  const GameDetail({Key? key}) : super(key: key);

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  int _seletedItem = 0;
  var _pages = [GameDetailView1(), GameDetailView2()];
  var _pageController = PageController();


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
