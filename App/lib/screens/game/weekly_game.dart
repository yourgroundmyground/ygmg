import 'package:app/const/colors.dart';
import 'package:app/widgets/modal.dart';
import 'package:flutter/material.dart';

class WeeklyGame extends StatefulWidget {
  const WeeklyGame({Key? key}) : super(key: key);

  @override
  State<WeeklyGame> createState() => _WeeklyGameState();
}

class _WeeklyGameState extends State<WeeklyGame> {
  @override
  void initState() {
    super.initState();
    // 2초 후에 showModal 함수 호출
    Future.delayed(Duration(seconds: 2), showModal);
  }

  void showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 최종 랭킹 값
    var rankingResult = 103;
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
                    // const SizedBox(height: 51,),
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
                          Text('$rankingResult 위', style: TextStyle(
                              fontSize: mediaWidth*0.05,
                              fontWeight: FontWeight.w600,
                              color: YGMG_RED
                          ),),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        DailyMap(),
                        Positioned(child: Container(
                          width: double.infinity,
                          height: mediaHeight*0.35,
                          color: Colors.blue,         // *나중에 지도 맵 넣기
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
                            child:DailyGameResult()
                        )
                      ],
                    )
                  ],
                ),
              ],
            )
        )
    );
  }
}



class DailyMap extends StatelessWidget {
  const DailyMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 미디어 사이즈
    final mediaHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Container(
        width: double.infinity,
        height: mediaHeight*0.55,
      ),
    );
  }
}

class DailyGameResult extends StatelessWidget {
  const DailyGameResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *게임결과 먹은 내 땅 면적
    var myGround = 1.44;
    // *게임결과 내 평균 속도
    var myPace = '4\'99\'\'';
    // *게임결과 달린 거리
    var myDist = 4.8;
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
            child: Image.asset('assets/images/testProfile.png'),      // *프로필 사진 넣어주기
          ),
          SizedBox(
            height: mediaHeight*0.02
          ),
          Text('58:25', style: TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('내 땅 크기', style: TextStyle(
                      fontSize: mediaWidth*0.025,
                      color: TEXT_GREY,
                    )),
                    SizedBox(height: mediaHeight*0.0025),
                    Text('${myGround}km²', style: TextStyle(       // *크기 변수설정
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
                    Text(myPace, style: TextStyle(              // *평균 속도 변경하기
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
                    Text('${myDist}km', style: TextStyle(
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


