import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/mypage/running_detail_view.dart';

class RunningDetail extends StatefulWidget {
  const RunningDetail({Key? key}) : super(key: key);
  @override
  _RunningDetailState createState() => _RunningDetailState();
}
// 페이지뷰
class _RunningDetailState extends State<RunningDetail> {
  int _seletedItem = 0;
  var _pages = [RunningDetailView1(), RunningDetailView2()];
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
