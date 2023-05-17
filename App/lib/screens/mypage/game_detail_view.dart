import 'package:app/screens/mypage/mypage.dart';
import 'package:app/utils/mypage/game_map.dart';
import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../utils/game/weeklyg_game_all_result_map.dart';

class GameDetailView1 extends StatefulWidget {
  final List<Map<String, dynamic>> gamedata;
  final int memberId;

  const GameDetailView1({
    required this.gamedata,
    required this.memberId,
    Key? key}) : super(key: key);

  @override
  State<GameDetailView1> createState() => _GameDetailView1State();
}

class _GameDetailView1State extends State<GameDetailView1> {
  double runningDistance = 0.0;
  double runningKcal = 0.0;
  double runningPace = 0.0;
  String runningTime = '';
  String formattedDate = '';
  String date = '';
  double gameArea = 0.0;
  bool gameRunningloaded = false;

  void getGameRunningDetail(String date) async {
  // 게임러닝 상세정보 조회 요청
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/running/detail/sum?memberId=${widget.memberId}&mode=GAME&startDate=$date&endDate=$date');
      setState(() {
        runningDistance = response.data['distance'];
        runningKcal = response.data['kcal'];
        runningPace = response.data['speed'];
        runningTime = response.data['time'];
        gameRunningloaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String formatDate(String dateString) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat outputFormat = DateFormat("M월 d일 h:mm a");
    DateTime dateTime = inputFormat.parse(dateString);
    String formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

  @override
  void initState() {
    for (var i = 0; i < widget.gamedata.length; i++) {
      setState(() {
        gameArea += widget.gamedata[i]['areaSize'];
      });
    }
    DateTime dateTime = DateTime.parse(widget.gamedata[0]['areaDate']);
    setState(() {
      formattedDate = formatDate(widget.gamedata[0]['areaDate']);
      date = DateFormat('yyyy-MM-dd').format(dateTime);
      getGameRunningDetail(date);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(mediaWidth*0.07, mediaHeight*0.05, mediaWidth*0.07, mediaHeight*0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate != '' ? formattedDate : '',
                    style: TextStyle(
                        fontSize: mediaWidth*0.075,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mypage(),
                          ),
                        );
                      }, icon: Image.asset('assets/images/closebtn.png')
                  )
                ],
              ),
              SizedBox(height: mediaHeight*0.04),
              Container(
                width: mediaWidth*0.7,
                height: mediaHeight*0.35,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: InkWell(
                  onLongPress: () {
                    if (widget.gamedata[0]['gameId'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeeklygGameResultAllMap(
                          gameId: widget.gamedata[0]['gameId'],
                        )),
                      );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                    child: widget.gamedata.isEmpty ? SizedBox() :
                    GameMap(
                      gamedata: widget.gamedata,
                    ),
                  ),
                )
              ),
              SizedBox(height: mediaHeight*0.05,),
              gameRunningloaded ?
              GameResultInfo(
                modalType: 'game',
                runningPace: runningPace,
                runningDist: runningDistance,
                runningKcal: runningKcal,
                runningTime: runningTime,
                areaSize: gameArea,
              ) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
