import 'package:app/const/colors.dart';
import 'package:app/utils/game/daily_game_result_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/state_provider_token.dart';

class DailyGame extends StatefulWidget {
  // double gameArea;
  // double runningPace;
  // double runningDist;

  const DailyGame({
    // required this.gameArea,
    // required this.runningPace,
    // required this.runningDist,
    Key? key}) : super(key: key);

  @override
  State<DailyGame> createState() => _DailyGameState();
}

class _DailyGameState extends State<DailyGame> {
  bool showSvg = false;
  int nowRanking = 103;

  // 현재랭킹 가져오기
  void getNowRanking() async {
    var dio = Dio();
    try {
      print('백에서 현재랭킹 가져오기!');
      var response = await dio.get('............');     // *요청 API 주소 넣기
      print(response.data);
      // 데이터 형식
      // {
      //   "kakaoEmail": "suasdfa1@naver.com",
      //   "memberBirth": "0512",
      //   "memberName": "adf",
      //   "memberNickname": "asdf",
      //   "memberWeight": 23,
      //   "profileImg": "https://asdfasdf.jpg"
      // }
      setState(() {
        nowRanking = response.data['nowRanking'];         // *받는 데이터 확인 후 현재랭킹 변경
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            showSvg = true;
          });
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    getNowRanking();
    super.initState();
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
          Stack(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      // const SizedBox(height: 51,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, 0, mediaHeight*0.02),
                        child: Text('결과', style: TextStyle(
                            fontSize: mediaWidth*0.07,
                            fontWeight: FontWeight.w700
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.03, mediaWidth*0.1, mediaHeight*0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('현재 랭킹 :', style: TextStyle(
                                fontSize: mediaWidth*0.05,
                                fontWeight: FontWeight.w600
                            ),),
                            Text('$nowRanking 위', style: TextStyle(
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
                          Positioned(child: Container(
                            width: double.infinity,
                            height: mediaHeight*0.35,
                            color: Colors.blue,         // *나중에 지도 맵 넣기
                            child: DailyGameResultMap(),
                          )),
                          Positioned(
                              top: mediaHeight*0.01,
                              left: (MediaQuery.of(context).size.width - mediaWidth*0.3) / 2,
                              child: Container(
                                width: mediaWidth*0.3,
                                height: mediaHeight*0.035,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(mediaWidth*0.1),
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('오늘 차지한 땅',
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
                              left: mediaWidth*0.1,
                              right: mediaWidth*0.1,
                              child:DailyGameResult()
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Positioned(
                left: mediaWidth*0.6,
                child: showSvg ? SvgPicture.asset('assets/images/donemark.svg') : Container()
              )
            ],
          ),

        ),
    );
  }
}


class DailyGameResult extends StatefulWidget {
  const DailyGameResult({Key? key}) : super(key: key);

  @override
  State<DailyGameResult> createState() => _DailyGameResultState();
}

class _DailyGameResultState extends State<DailyGameResult> {
  var profileImg;
  var _tokenInfo;
  // *게임참여시간, 면적크기, 평균속도, 달린 거리
  String gameTime = '58:25';
  double gameArea = 1.44;
  String runningPace = '4\'99\'\'';
  double runningDist = 4.8;

  // 마이페이지 회원정보 조회 요청
  void getGameOverMember() async {
    var dio = Dio();
    try {
      print('백에서 마이페이지 회원정보 가져오기!');
      print(_tokenInfo.accessToken);
      dio.options.headers['Authorization'] = 'Bearer ${_tokenInfo.accessToken}';
      var response = await dio.get('http://k8c107.p.ssafy.io:8080/api/member/mypage');
      print(response.data);
      // 데이터 형식
      // {
      //   "kakaoEmail": "suasdfa1@naver.com",
      //   "memberBirth": "0512",
      //   "memberName": "adf",
      //   "memberNickname": "asdf",
      //   "memberWeight": 23,
      //   "profileImg": "https://asdfasdf.jpg"
      // }
      setState(() {
        profileImg = response.data['profileImg'];
      });
    } catch (e) {
      print(e.toString());
    }
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
    _loadTokenInfo().then((_) {
      getGameOverMember();
    });
    super.initState();
  }

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
                        image: NetworkImage('$profileImg'),
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
          Text(gameTime, style: TextStyle(
              fontSize: mediaWidth*0.12,
              fontWeight: FontWeight.w900
          )),
          SizedBox(
            height: mediaHeight*0.02
          ),
          Container(
            width: mediaWidth*0.6,
            height: mediaHeight*0.05,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('내 땅 크기', style: TextStyle(
                      fontSize: mediaWidth*0.025,
                      color: TEXT_GREY,
                    )),
                    SizedBox(height: mediaHeight*0.0025),
                    Text('${gameArea}km²', style: TextStyle(
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
                    Text(runningPace, style: TextStyle(              // *평균 속도 변경하기
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
                    Text('${runningDist}km', style: TextStyle(
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


