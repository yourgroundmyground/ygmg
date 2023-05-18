import 'package:app/const/colors.dart';
import 'package:app/main.dart';
import 'package:app/widgets/modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../const/state_provider_token.dart';
import '../../utils/game/weekly_game_result_map.dart';
import '../../utils/game/weeklyg_game_all_result_map.dart';

class WeeklyGame extends StatefulWidget {
  const WeeklyGame({Key? key}) : super(key: key);

  @override
  State<WeeklyGame> createState() => _WeeklyGameState();
}

class _WeeklyGameState extends State<WeeklyGame> {
  var _tokenInfo;
  var profileImg;
  var gameId;
  var startDate;
  var endDate;
  var resultArea;
  bool isModalOpen = true;
  int? weekRanking;
  bool isloaded = false;
  var time;
  var speed;
  var distance;
  var kcal;

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  // 마이페이지 회원정보 조회 요청
  void getGameOverMember() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/me/${_tokenInfo.memberId}');
      setState(() {
        profileImg = response.data['profileUrl'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 저번 게임 아이디 가져오기
  void getGameId() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/gameId');
      setState(() {
        gameId = response.data - 1;
      });
      getGameIdInfo();
      getWeekRanking();
    } catch (e) {
      print(e.toString());
    }
  }

  // 게임아이디 날짜 정보 조회
  void getGameIdInfo() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/$gameId');

      String formattedStart = DateFormat('yyyy-MM-dd').format(DateTime.parse(response.data['gameStart']));
      String formattedEnd = DateFormat('yyyy-MM-dd').format(DateTime.parse(response.data['gameEnd']));
      setState(() {
        startDate = formattedStart;
        endDate = formattedEnd;
      });
      getWeekRunning();

    } catch (e) {
      print(e.toString());
    }
  }

  // 최종랭킹 가져오기
  void getWeekRanking() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/result/$gameId/${_tokenInfo.memberId}');   // *테스트용

      setState(() {
        weekRanking = response.data['resultRanking'];
        resultArea = response.data['resultArea'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 최종게임 러닝 가져오기
  void getWeekRunning() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/running/detail/sum?memberId=${_tokenInfo.memberId}&mode=GAME&startDate=$startDate&endDate=$endDate');   // *테스트용
      setState(() {
        time = response.data['time'];
        speed = response.data['speed'];
        distance = response.data['distance'];
        kcal = response.data['kcal'];
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isloaded = true;
    });
  }

  @override
  void initState() {
    _loadTokenInfo().then((value) => {
      getGameOverMember(),
      getGameId(),
  });
    super.initState();
    Future.delayed(Duration(seconds: 1), showModal);
  }

  void showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(modalType: 'gameRank', weeklyRank: weekRanking);
      },
    );
    setState(() {
      isModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: false,
          child:
            Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, 0, mediaHeight*0.02),
                      child: Text('주간 결과', style: TextStyle(
                          fontSize: mediaWidth*0.07,
                          fontWeight: FontWeight.w700
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.03, mediaWidth*0.1, mediaHeight*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('최종 랭킹 :', style: TextStyle(
                              fontSize: mediaWidth*0.05,
                              fontWeight: FontWeight.w600
                          ),),
                          Text(weekRanking == null || isModalOpen == true ? '' : '$weekRanking 위', style: TextStyle(
                              fontSize: mediaWidth*0.05,
                              fontWeight: FontWeight.w600,
                              color: YGMG_RED
                          ),),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: mediaHeight*0.55,
                        ),
                        Positioned(child: InkWell(
                          onLongPress: () {
                            if (gameId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WeeklygGameResultAllMap(
                                  gameId: gameId,
                                )),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: mediaHeight * 0.35,
                            color: Colors.white,
                            child: gameId != null ? WeeklyGameResultMap(
                                memberId: _tokenInfo.memberId,
                                gameId: gameId,
                              ) : Center(
                              child: CircularProgressIndicator(
                                color: YGMG_SKYBLUE
                              )
                            )
                          ),
                        )),
                        Positioned(
                          top: mediaHeight*0.01,
                          left: (MediaQuery.of(context).size.width - mediaWidth*0.35) / 2,
                          child: Container(
                              width: mediaWidth*0.35,
                              height:  mediaHeight*0.035,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(mediaWidth*0.1),
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('MY GROUND 내 땅',
                                    style: TextStyle(
                                      fontSize: mediaWidth*0.028,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )),
                        Positioned(
                            top: mediaHeight*0.3,
                            left:  mediaWidth*0.1,
                            right:  mediaWidth*0.1,
                            child: resultArea != null && isloaded ? DailyGameResult(
                              areaSize: resultArea,          // *변경 필요
                              runningPace: speed,
                              runningDist: distance,
                              runningDuration: time,
                              profileImg: profileImg,
                            ) : SizedBox()
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: mediaHeight*0.03,),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false,
                    );
                  },
                  child: Image.asset('assets/images/Home_button.png')),
              ],
            )
        )
    );
  }
}

class DailyGameResult extends StatelessWidget {
  final double areaSize;
  final double runningPace;
  final double runningDist;
  final String runningDuration;
  final String? profileImg;

  const DailyGameResult({
    required this.areaSize,
    required this.runningPace,
    required this.runningDist,
    required this.runningDuration,
    required this.profileImg,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mediaWidth*0.05),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: mediaWidth*0.16,
            height: mediaWidth*0.16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
            ),
            child: Stack(
              children: [
                Positioned(
                  top: (mediaWidth * 0.16 - mediaWidth * 0.13) / 2,
                  left: (mediaWidth * 0.16 - mediaWidth * 0.13) / 2,
                  child: Container(
                    width: mediaWidth * 0.13,
                    height: mediaWidth * 0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profileImg ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaHeight*0.02
          ),
          Text(runningDuration, style: TextStyle(
            fontSize: mediaWidth*0.12,
            fontWeight: FontWeight.w900
          )),
          SizedBox(
            height: mediaHeight*0.02
          ),
          Container(
            width: mediaWidth*0.7,
            height: mediaHeight*0.05,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('내 땅 크기', style: TextStyle(
                      fontSize: mediaWidth*0.025,
                      color: TEXT_GREY,
                    )),
                    SizedBox(height: mediaHeight*0.0025),
                    Text('${(areaSize*10000000000).toStringAsFixed(0)}m²',
                      style: TextStyle(
                        fontSize: mediaWidth*0.045,
                        fontWeight: FontWeight.w900
                    ),)
                  ],
                ),
                VerticalDivider(
                    thickness: 1,
                    color: TEXT_GREY
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('페이스', style: TextStyle(
                      fontSize: mediaWidth*0.025,
                      color: TEXT_GREY,
                    )),
                    SizedBox(height: mediaHeight*0.0025),
                    Text('${runningPace.floor()}\'${(runningPace.remainder(1) * 10).floor()}\'\'',
                      style: TextStyle(
                        fontSize: mediaWidth*0.045,
                        fontWeight: FontWeight.w900
                    ),)
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  color: TEXT_GREY,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('달린 거리', style: TextStyle(
                      fontSize: mediaWidth*0.025,
                      color: TEXT_GREY,
                    )),
                    SizedBox(height: mediaHeight*0.0025),
                    Text('${runningDist.toStringAsFixed(1)}km', style: TextStyle(
                        fontSize: mediaWidth*0.045,
                        fontWeight: FontWeight.w900
                    ),)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


