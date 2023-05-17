import 'package:app/screens/mypage/game_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
import '../const/state_provider_token.dart';
import 'package:intl/intl.dart';

class MyWeeklyGame extends StatefulWidget {
  final int memberId;
  final int nowgameId;
  final String tuesday;
  final String sunday;

  const MyWeeklyGame({
    required this.memberId,
    required this.nowgameId,
    required this.tuesday,
    required this.sunday,
    Key? key}) : super(key: key);

  @override
  State<MyWeeklyGame> createState() => _MyWeeklyGameState();
}

class _MyWeeklyGameState extends State<MyWeeklyGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var _tokenInfo;
  var startdate;
  var enddate;
  var weeksAgo;
  int nowRank = 0;
  double nowArea = 0;
  int notNowRank = 0;
  double notNowArea = 0;
  String runningTime = '';
  double runningDistance = 0;
  double runningKcal = 0;
  double runningSpeed = 0;
  bool nowRankArealoaded = false;
  bool rankArealoaded = false;
  bool runningDataloaded = false;
  int notNowIndex = 0;

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  // 날짜형식 변경
  void changeDateFormat() {
    DateTime mondayObj = DateFormat('yyyy-MM-dd').parse(widget.tuesday);
    DateTime sundayObj = DateFormat('yyyy-MM-dd').parse(widget.sunday);
    startdate = DateFormat('M월 d일').format(mondayObj);
    enddate = DateFormat('M월 d일').format(sundayObj);

    // 현재 시간을 구합니다.
    DateTime currentTime = DateTime.now();
    // 현재 시간과 enddate 사이의 차이를 계산합니다.
    Duration difference = currentTime.difference(sundayObj);
    weeksAgo = (difference.inDays / 7).floor();
    notNowIndex = weeksAgo;

    if (weeksAgo >= 0) {
      if (weeksAgo == 0) {
        weeksAgo = '저번 주';
      } else if (weeksAgo < 4) {
        weeksAgo = '${weeksAgo + 1} 주 전';
      }
    } else {
      weeksAgo = '이번 주';
    }
  }

  // 마이페이지 현재게임중 조회 요청
  void getGameNowResult() async {
    var dio = Dio();

    try {
      int memberId = widget.memberId;
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/ranking/$memberId');
      setState(() {
        nowRank = response.data['rank'];
        nowArea = response.data['areaSize'];
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      nowRankArealoaded = true;
    });
  }


  // 마이페이지 게임결과 조회 요청
  void getGameResult() async {
    var dio = Dio();

    try {
      int memberId = widget.memberId;
      if (-notNowIndex+2 != widget.nowgameId) {
        var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/result/${-notNowIndex+2}/$memberId');
        setState(() {
          notNowRank = response.data['resultRanking'];
          notNowArea = response.data['resultArea'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      rankArealoaded = true;
    });
  }

  // 마이페이지 게임의 러닝데이터 조회 요청
  void getGameRunningData() async {
    var dio = Dio();

    try {
      int memberId = widget.memberId;
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/running/detail/sum?memberId=$memberId&mode=GAME&startDate=${widget.tuesday}&endDate=${widget.sunday}');
      setState(() {
        runningTime = response.data['time'];
        runningDistance = response.data['distance'];
        runningKcal = response.data['kcal'];
        runningSpeed = response.data['speed'];
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      runningDataloaded = true;
    });
  }

  @override
  void initState() {
    _loadTokenInfo().then((value) => null);
    changeDateFormat();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _controller.forward();
    super.initState();
    getGameNowResult();
    getGameResult();
    getGameRunningData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return rankArealoaded && runningDataloaded && nowRankArealoaded ? FadeTransition(
      opacity: _controller,
      child: TapToExpand(
        scrollPhysics: NeverScrollableScrollPhysics(),
        onTapPadding: 10,
        closedHeight: mediaHeight*0.1,
        scrollable: true,
        borderRadius: 40,
        openedHeight: mediaHeight*0.55,
        trailing: Icon(Icons.expand_circle_down, color: YGMG_ORANGE),
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: mediaHeight*0.03, horizontal: mediaWidth*0.03),
              width: mediaWidth*0.85,
              height: mediaHeight*0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mediaWidth*0.05),
                color: Colors.white,
              ),
              child: ListView(
                controller: ScrollController(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(notNowIndex == -1 ? '${_tokenInfo?.memberNickname ?? ''}님의 현재 순위' : '${_tokenInfo.memberNickname}님의 최종 순위',
                                style: TextStyle(
                                    fontSize: mediaWidth*0.04,
                                    color: Colors.black45
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: mediaHeight*0.005),
                          Row(
                            children: [
                              Text(notNowIndex != -1 ? '$notNowRank 위' : '$nowRank 위',
                                style: TextStyle(
                                  fontSize: mediaWidth*0.07,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: mediaHeight*0.02),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: mediaHeight*0.015, horizontal: mediaWidth*0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mediaWidth*0.02),
                      color: Color(0xFFF3F7FF),
                    ),
                    child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('내 땅 크기',
                                        style: TextStyle(
                                            fontSize: mediaWidth*0.04,
                                            color: Colors.black45
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: mediaHeight*0.005),
                                  Row(
                                    children: [
                                      Text(notNowIndex != -1 ? '${(notNowArea * 10000000000).toStringAsFixed(0)} m²' : '${(nowArea * 10000000000).toStringAsFixed(0)} m²',    // *단위 수정
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.07,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                          GameDetail(
                                            gameId: -notNowIndex+2,
                                            memberId: widget.memberId,
                                            start: widget.tuesday,
                                            end: widget.sunday,
                                        )),
                                      );
                                    },
                                    child: SizedBox(
                                      width: mediaWidth*0.08,
                                      child: Image.asset('assets/images/right-arrow.png'),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: mediaHeight*0.008),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: mediaHeight*0.015, horizontal: mediaWidth*0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mediaWidth*0.02),
                      color: Color(0xFFF3F7FF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('누적 달리기 시간',
                                  style: TextStyle(
                                      fontSize: mediaWidth*0.04,
                                      color: Colors.black45
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaHeight*0.005),
                            Row(
                              children: [
                                Text(runningTime,
                                  style: TextStyle(
                                    fontSize: mediaWidth*0.07,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: mediaHeight*0.01),
                        Row(
                          children: [
                            Text('평균 달리기 기록',
                              style: TextStyle(
                                fontSize: mediaWidth*0.04,
                                color: Colors.black45
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mediaHeight*0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                children: [
                                  Container(
                                      width: mediaWidth*0.05,
                                      alignment: Alignment.topCenter,
                                      child:
                                      Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: Image.asset('assets/images/runningimg.png')
                                      )
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(runningDistance.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.045,
                                          fontWeight: FontWeight.w700
                                      ),),
                                      Text('km',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: mediaWidth*0.03,
                                            color: TEXT_GREY
                                        ),),
                                    ],
                                  )
                                ]
                            ),
                            VerticalDivider(
                              thickness: 1,
                              color: TEXT_GREY
                            ),
                            Row(
                                children: [
                                  Container(
                                      width: mediaWidth*0.05,
                                      alignment: Alignment.topCenter,
                                      child:
                                      Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: Image.asset('assets/images/fireimg.png')
                                      )
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(runningKcal.toStringAsFixed(0),
                                       style: TextStyle(
                                          fontSize: mediaWidth*0.045,
                                          fontWeight: FontWeight.w700
                                      ),),
                                      Text('kcal',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.03,
                                          color: TEXT_GREY
                                        )
                                      ),
                                    ],
                                  )
                                ]
                            ),
                            VerticalDivider(
                              thickness: 1,
                              color: TEXT_GREY,
                            ),
                            Row(
                                children: [
                                  Container(
                                      width: mediaWidth*0.05,
                                      alignment: Alignment.topCenter,
                                      child:
                                      Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: Image.asset('assets/images/lighteningimg.png')
                                      )
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(runningSpeed.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.045,
                                          fontWeight: FontWeight.w700
                                        )
                                      ),
                                      Text('km/hr',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.03,
                                          color: TEXT_GREY
                                        )
                                      ),
                                    ],
                                  )
                                ]
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        title: SizedBox(
          width: mediaWidth*0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/runningimg.png'),
                radius: 20,
              ),
              Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$weeksAgo 땅따먹기', style: TextStyle(
                            fontSize: mediaWidth*0.045,
                            fontWeight: FontWeight.w700
                        ),),
                        Text('$startdate - $enddate',
                          style: TextStyle(
                              fontSize: mediaWidth*0.032,
                              color: TEXT_GREY
                          ),
                        ),
                      ],
                    )
                  ]
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mediaHeight*0.007,),
                      Text(notNowIndex != -1 ? '${(notNowArea * 10000).toStringAsFixed(2)} km²' : '${(nowArea * 10000).toStringAsFixed(2)} km²',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: mediaWidth*0.032,
                              fontWeight: FontWeight.w700
                          )
                      ),
                      Text('${runningKcal.toStringAsFixed(0)} kcal ',
                        style: TextStyle(
                            fontSize: mediaWidth*0.032,
                            color: TEXT_GREY
                        ),
                      ),
                    ],
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    ) : SizedBox();
  }
}
