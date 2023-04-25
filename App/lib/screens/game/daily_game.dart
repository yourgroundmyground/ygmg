import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

class DailyGame extends StatelessWidget {
  const DailyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 혅재 랭킹 값
    var nowRanking = 103;
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
                    padding: EdgeInsets.fromLTRB(38, 51, 0, 0),
                    child: Text('결과', style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700
                    ),),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 33, 45, 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('현재 랭킹 :', style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),),
                        Text('$nowRanking 위', style: TextStyle(
                          fontSize: 20,
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
                        height: 300,
                        color: Colors.blue,         // *나중에 지도 맵 넣기
                      )),
                      Positioned(
                        top: 5,
                        left: (MediaQuery.of(context).size.width - 155) / 2,
                        child: Container(
                          width: 155,
                          height: 29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('오늘 차지한 땅',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      )),
                      Positioned(
                        top: 250,
                        left: 50,
                        right: 50,
                        child:DailyGameResult()
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}



class DailyMap extends StatelessWidget {
  const DailyMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        height: 500,
      ),
    );
  }
}

class DailyGameResult extends StatelessWidget {
  const DailyGameResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // *게임결과 먹은 내 땅 면적
    var myGround = 1.44;
    // *게임결과 내 평균 속도
    var myPace = '4\'99\'\'';
    // *게임결과 달린 거리
    var myDist = 4.8;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width:  76,
            height: 76,
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
            ),
            child: Image.asset('assets/testProfile.png'),      // *프로필 사진 넣어주기
          ),
          const SizedBox(height: 10),
          Text('58:25', style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900
          )),
          const SizedBox(height: 16.0,),
          Container(
            width: 259,
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('내 땅 크기', style: TextStyle(
                      fontSize: 12,
                      color: TEXT_GREY,
                    )),
                    const SizedBox(height: 4.0,),
                    Text('${myGround}km²', style: TextStyle(       // *크기 변수설정
                      fontSize: 20,
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
                      fontSize: 12,
                      color: TEXT_GREY,
                    )),
                    const SizedBox(height: 4.0,),
                    Text(myPace, style: TextStyle(              // *평균 속도 변경하기
                        fontSize: 20,
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
                      fontSize: 12,
                      color: TEXT_GREY,
                    )),
                    const SizedBox(height: 4.0,),
                    Text('${myDist}km', style: TextStyle(
                        fontSize: 20,
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


