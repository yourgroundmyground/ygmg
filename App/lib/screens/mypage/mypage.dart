import 'package:app/const/colors.dart';
import 'package:app/const/state_provider_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../const/state_provider_token.dart';


class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}
class _MypageState extends State<Mypage> {
  List<dynamic> runningList = [];
  var profileImg;
  var _tokenInfo;

  // 마이페이지 회원정보 조회 요청
  void getMyPageMember() async {
    var dio = Dio();
    dio.interceptors.add(
        TokenInterceptor(_tokenInfo)
    );

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

  // 마이페이지 회원 전체러닝정보 조회 요청
  void getMyPageRunning() async {
    var dio = Dio();
    dio.interceptors.add(TokenInterceptor(_tokenInfo));

    try {
      print('백에서 회원 전체러닝정보 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io:8081/api/running/${_tokenInfo.memberId}',
        // options: Options(
          // headers: {
          //   'Authorization': 'Bearer ${_tokenInfo.accessToken}',    // *토큰 넣어주기
          // }
        // )
      );
      print('러닝정보 가져오기 ${response.data}');
      // 데이터 형식
      // {
      //   "runningDate": "2023-05-08",
      //   "runningDistance": 1.2,
      //   "runningId": 0,
      //   "runningType": "RUNNING"
      // },
      setState(() {
        runningList = response.data['runningList'];
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
    super.initState();
    _loadTokenInfo().then((_) {
      getMyPageMember();
      getMyPageRunning();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 결과
    void main() async {
      await initializeDateFormatting('ko_KR', null);
      // 오늘의 날짜 가져오기
      DateTime today = DateTime.now();

      // 이번 주의 첫 날짜 가져오기 (월요일)
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      // 이번 주의 마지막 날짜 가져오기 (일요일)
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      // 이번 주의 모든 날짜 가져오기
      List<DateTime> daysOfWeek = [];
      for (var i = 0; i < 7; i++) {
        daysOfWeek.add(startOfWeek.add(Duration(days: i)));
      }

      // 출력하기
      for (var day in daysOfWeek) {
        print(DateFormat.yMd('ko_KR').format(day));
      }
      var now = DateTime.now();
      // var today = DateFormat('yyyy.MM.dd EEEE', 'ko_KR').format(now);
      var weekdayName = DateFormat('EEEE', 'ko_KR').format(now);
      var nextWeek = List.generate(
        7,
            (index) => DateFormat('yyyy.MM.dd EEEE', 'ko_KR').format(now.add(Duration(days: index))),
      );

      print(today);
      print(weekdayName);
      print(nextWeek);
    }
    return  Scaffold(
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
                    child: Container(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '안녕하세요, ${_tokenInfo?.memberNickname ?? ''} 님!',
                            style: TextStyle(
                                fontSize: mediaWidth*0.045,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(255, 255, 255, 1)
                            ),
                          )),
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
                            child: Container(
                              width: mediaWidth*0.18,
                              height: mediaWidth*0.18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage('$profileImg'),
                                  fit: BoxFit.cover,
                                ),
                              )
                            )
                          )
                        ])
                      ),
                  Positioned(
                      right: mediaWidth*0.05,
                      top: mediaHeight*0.125,
                      child: Image.asset('assets/images/Gear.png'),
                  ),
                  Positioned(
                    left: mediaWidth*0.05,
                    top: mediaHeight*0.04,
                    // margin: EdgeInsets.fromLTRB(mediaWidth*0.5, mediaHeight*0.1, 0, mediaHeight*0.1),
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
                            // spreadRadius: 7,
                            blurRadius: 28,
                            // offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('달린 거리',
                                style: TextStyle(
                                  fontSize: mediaWidth*0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start
                            ),
                            runningList.isEmpty ?
                              SizedBox(
                                width: mediaWidth*0.8,
                                height: mediaHeight*0.3,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: YGMG_ORANGE,
                                  )
                                ),
                              ) :
                            RunningChart(
                              runningList: runningList,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        // MyWeeklyGame(),
                        // MyWeeklyGame(),
                        // MyWeeklyGame(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: DrawPolygon(),
      floatingActionButton: FloatingActionButton(
        onPressed: main,
        child: Icon(Icons.ice_skating),
      ),
    );
  }
}