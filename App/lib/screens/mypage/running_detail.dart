import 'package:flutter/material.dart';
import 'package:app/screens/mypage/running_detail_view.dart';

class RunningDetail extends StatefulWidget {
  final String weekDay;
  final List<int> runningIds;

  const RunningDetail({
    required this.weekDay,
    required this.runningIds,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RunningDetailState();
}
// 페이지뷰
class _RunningDetailState extends State<RunningDetail> {
  List<Widget> _pages = [];
  final _pageController = PageController();

  @override
  void initState() {
    // print(widget.weekDay);
    // print(widget.runningIds);
    // 러닝 기록 개수만큼 페이지 생성
    setState(() {
      _pages = List.generate(
        widget.runningIds.length,
        (index) => RunningDetailView1(
          runningId: widget.runningIds[index],
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: PageView(
          controller: _pageController,
          children: _pages,
        ),
      ),
    );
  }
}
