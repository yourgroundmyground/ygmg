import 'package:app/utils/mypage/running_map.dart';
import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


class RunningDetailView1 extends StatefulWidget {
  const RunningDetailView1({Key? key}) : super(key: key);

  @override
  State<RunningDetailView1> createState() => _RunningDetailView1State();
}

class _RunningDetailView1State extends State<RunningDetailView1> {
  int runningDetailId = 0;
  double runningDistance = 0.0;
  String runningEnd = '';
  double runningKcal = 0.0;
  double runningPace = 0.0;
  String runningTime = '';
  String formattedDate = '';

  // 러닝 상세정보 조회 요청
  void getRunningDetail() async {
    var dio = Dio();
    try {
      print('백에서 러닝상세정보 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io:8081/api/running/detail/{runningId}',
        options: Options(
          headers: {
            // 'Authorization': 'Bearer $token',    // *토큰 넣어주기
          }
        )
      );
      print(response.data);
      // 데이터 형식
      // {
      //   "runningDetailId": 0,
      //   "runningDistance": 0,
      //   "runningEnd": "yyyy-MM-dd HH:mm:ss",
      //   "runningKcal": 0,
      //   "runningMode": "string",
      //   "runningPace": 0,
      //   "runningStart": "yyyy-MM-dd HH:mm:ss",
      //   "runningTime": "HH:mm:ss"
      // }
      setState(() {

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
    print(formattedDate);
    return formattedDate;
  }

  @override
  void initState() {
    getRunningDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth*0.07, mediaHeight*0.05, mediaWidth*0.07, mediaHeight*0.02),
            // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // formatDate(runningEnd),          // *러닝 종료 시간 넣어주기
                      formatDate('2023-04-20 11:02:00'),
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
                        }, icon: Image.asset('assets/images/closebtn.png', width: mediaWidth*0.08,)
                    )
                  ],
                ),
                SizedBox(height: mediaHeight*0.04,),
                // 달리기 경로 들어갈 컨테이너
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                    child: RunningMap(
                      // runningDetailId: runningDetailId
                      runningDetailId: 0, // *테스트용 아이디
                    ),
                  ),
                ),
                SizedBox(height: mediaHeight*0.05,),
                GameResultInfo(
                  modalType: 'running',
                  runningPace: runningPace,
                  runningDist: runningDistance,
                  runningKcal: runningKcal,
                  runningTime: runningTime,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}