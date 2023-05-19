import 'package:app/const/colors.dart';
import 'package:app/const/state_provider_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/chart.dart';
import 'package:intl/intl.dart';
import '../../const/state_provider_token.dart';
import '../../widgets/my_weekly_game.dart';


class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}
class _MypageState extends State<Mypage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<dynamic> runningList = [];
  var profileImg;
  var _tokenInfo;
  var gameId;
  bool runningListLoading = true;
  // 현재 날짜까지 각 주의 월요일과 일요일을 구합니다.
  List<DateTime> tuesdaysList = [];
  List<DateTime> sundaysList = [];

  // 마이페이지 회원정보 조회 요청
  void getMyPageMember() async {
    var dio = Dio();
    dio.interceptors.add(
        TokenInterceptor(_tokenInfo)
    );

    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/me/${_tokenInfo.memberId}');
      setState(() {
        profileImg = response.data['profileUrl'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 마이페이지 회원 전체러닝정보 조회 요청
  void getMyPageRunning() async {
    var dio = Dio();

    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/running/${_tokenInfo.memberId}');
      setState(() {
        runningList = response.data['runningList'];
        runningListLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 현재 게임아이디 조회
  void getGameId() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/gameId');
      setState(() {
        gameId = response.data;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 출시일 포함 각 주의 월요일과 일요일
  void getTuesdaySunday() {
    DateTime releaseDate = DateTime(2023, 5, 1);
    DateTime now = DateTime.now();

    // 출시일 이후의 화요일과 일요일을 구합니다.
    DateTime startTuesday = releaseDate;
    while (startTuesday.weekday != DateTime.tuesday) {
      startTuesday = startTuesday.add(Duration(days: 1));
    }
    DateTime startSunday = startTuesday.add(Duration(days: 6));

    // 현재 날짜의 주차까지 화요일과 일요일을 구합니다.
    DateTime currentTuesday = startTuesday;
    DateTime currentSunday = startSunday;

    List<DateTime> allTuesdays = [];
    List<DateTime> allSundays = [];

    while (currentSunday.isBefore(now)) {
      allTuesdays.add(currentTuesday);
      allSundays.add(currentSunday);
      currentTuesday = currentTuesday.add(Duration(days: 7));
      currentSunday = currentSunday.add(Duration(days: 7));
    }

    DateTime nowdate = DateTime(now.year, now.month, now.day);

    DateTime nowTuesday = nowdate.subtract(Duration(days: nowdate.weekday - 2));
    DateTime nowSunday = nowTuesday.add(Duration(days: 6));

    allTuesdays.add(nowTuesday);
    allSundays.add(nowSunday);

    // 출시일 이후의 화요일과 일요일만 따로 리스트로 구성합니다.
    List<DateTime> tuesdays = [];
    List<DateTime> sundays = [];

    for (int i = 0; i < allTuesdays.length; i++) {
      if (allTuesdays[i].isAfter(releaseDate)) {
        tuesdays.add(allTuesdays[i]);
        sundays.add(allSundays[i]);
      }
    }

    tuesdaysList = tuesdays;
    sundaysList = sundays;
  }

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    getGameId();
    _loadTokenInfo().then((_) {
      getMyPageMember();
      getMyPageRunning();
    });
    getTuesdaySunday();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

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
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: mediaWidth*0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(mediaWidth*0.05), bottomRight: Radius.circular(mediaWidth*0.05)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 252, 99, 99),
                            Color.fromRGBO(255, 66, 41, 1.0),
                          ]
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  Positioned(
                    top: mediaHeight*0.12,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        '안녕하세요, ${_tokenInfo?.memberNickname ?? ''} 님!',
                        style: TextStyle(
                          fontSize: mediaWidth*0.045,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(255, 255, 255, 1)
                        ),
                      )
                    ),
                  ),
                  Positioned(
                      left: mediaWidth*0.05,
                      top: mediaHeight*0.1,
                      child: Stack(
                        children: [
                          Container(
                            width: mediaWidth*0.2,
                            height: mediaWidth*0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFFBCA92),
                                      Color(0xFFEF7EC2)
                                    ]
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0,4),
                                  )
                                ]
                            )
                          ),
                          Positioned(
                            left: mediaWidth*0.01,
                            top: mediaWidth*0.01,
                            child: profileImg != null ? Container(
                              width: mediaWidth*0.18,
                              height: mediaWidth*0.18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(profileImg),
                                  fit: BoxFit.cover,
                                ),
                              )
                            ) : SizedBox(
                              width: mediaWidth*0.18,
                              height: mediaWidth*0.18,
                              child: Center(
                                child: CircularProgressIndicator(),
                              )
                            )
                          )
                        ])
                      ),
                  Positioned(
                    left: mediaWidth*0.05,
                    top: mediaHeight*0.04,
                    child: Text('마이페이지', style: TextStyle(
                        fontSize: mediaWidth*0.07,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: ScrollController(),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, mediaHeight*0.2),
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                      width: mediaWidth*0.9,
                      height: mediaWidth*0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(mediaWidth*0.04),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 28,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('달린 거리',
                              style: TextStyle(
                                fontSize: mediaWidth*0.04,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start
                            ),
                            runningList.isNotEmpty ?
                              RunningChart(
                                runningList: runningList,
                              )
                              : SizedBox(
                                width: mediaWidth * 0.8,
                                height: mediaHeight * 0.3,
                                child: Center(
                                  child: runningListLoading == true ?
                                  CircularProgressIndicator(
                                    color: YGMG_ORANGE,
                                  )
                                  // : Text(
                                  //     '러닝을 시작하세요!',
                                  //     style: TextStyle(
                                  //       fontSize: mediaWidth*0.05,
                                  //       fontWeight: FontWeight.w700,
                                  //       color: YGMG_ORANGE,
                                  //       letterSpacing: 1
                                  //     ),
                                  //   )
                                  : FadeTransition(
                                    opacity: _controller,
                                    child: Text(
                                      '러닝을 시작하세요!',
                                      style: TextStyle(
                                        fontSize: mediaWidth*0.05,
                                        fontWeight: FontWeight.w700,
                                        color: YGMG_ORANGE,
                                        letterSpacing: 1
                                      ),
                                    ),
                                  )
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                      _tokenInfo != null && _tokenInfo.memberId != null && gameId != null ?
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sundaysList.length,
                          itemBuilder: (context, index) {
                            final reversedIndex = sundaysList.length - 1 - index;
                            if (reversedIndex < 4) {
                              return MyWeeklyGame(
                                memberId: _tokenInfo.memberId,
                                nowgameId: gameId,
                                tuesday: DateFormat('yyyy-MM-dd').format(tuesdaysList[reversedIndex]),
                                sunday: DateFormat('yyyy-MM-dd').format(sundaysList[reversedIndex].subtract(Duration(days: 1))),
                              );
                            } else {
                              return SizedBox(); // 빈 컨테이너 반환
                            }
                          },
                        ) : SizedBox()
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}