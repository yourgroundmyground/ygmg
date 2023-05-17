import 'package:app/const/colors.dart';
import 'package:app/utils/game/daily_game_result_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/state_provider_token.dart';

class DailyGame extends StatefulWidget {
  final double runningPace;
  final double runningDist;
  final String runningDuration;

  const DailyGame({
    required this.runningPace,
    required this.runningDist,
    required this.runningDuration,
    Key? key}) : super(key: key);

  @override
  State<DailyGame> createState() => _DailyGameState();
}

class _DailyGameState extends State<DailyGame> {
  bool showSvg = false;
  int? nowRanking;
  var _tokenInfo;
  var profileImg;
  var areaSize;

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

  // 현재랭킹 가져오기
  void getNowRanking() async {
    var dio = Dio();
    try {
      var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/ranking/${_tokenInfo.memberId}');

      setState(() {
        nowRanking = response.data['rank'];
        areaSize = response.data['areaSize'];
        Future.delayed(Duration(seconds: 1), () {
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
    _loadTokenInfo().then((value) => {
      getGameOverMember(),
      getNowRanking()
    });
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
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, 0, mediaHeight*0.02),
                        child: Text('결과',
                          style: TextStyle(
                            fontSize: mediaWidth*0.07,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.03, mediaWidth*0.1, mediaHeight*0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('현재 랭킹 :',
                              style: TextStyle(
                                fontSize: mediaWidth*0.05,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(nowRanking != null ? '$nowRanking 위' : '',
                              style: TextStyle(
                                fontSize: mediaWidth*0.05,
                                fontWeight: FontWeight.w600,
                                color: YGMG_RED
                              ),
                            ),
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
                            color: Colors.transparent,
                            child: _tokenInfo != null ? DailyGameResultMap(
                              memberId: _tokenInfo.memberId,
                            ) : Center(child: CircularProgressIndicator(),)
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
                            )
                          ),
                          Positioned(
                            top: mediaHeight*0.3,
                            left: mediaWidth*0.1,
                            right: mediaWidth*0.1,
                            child: profileImg != null && areaSize != null ?
                            DailyGameResult(
                              areaSize: areaSize,
                              runningPace: widget.runningPace,
                              runningDist: widget.runningDist,
                              runningDuration: widget.runningDuration,
                              profileImg: profileImg,
                            ) : SizedBox()
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
  State<DailyGameResult> createState() => _DailyGameResultState();
}

class _DailyGameResultState extends State<DailyGameResult> {

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
                        image: NetworkImage(widget.profileImg ?? ''),
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
          Text(widget.runningDuration, style: TextStyle(
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
                    Text('${(widget.areaSize*10000000000).toStringAsFixed(0)}m²', style: TextStyle(
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
                    Text('${widget.runningPace.floor()}\'${(widget.runningPace.remainder(1) * 10).floor()}\'\'', style: TextStyle(              // *평균 속도 변경하기
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
                    Text('${widget.runningDist.toStringAsFixed(1)}km', style: TextStyle(
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


