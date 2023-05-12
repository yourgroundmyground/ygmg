import 'package:app/utils/mypage/running_map.dart';
import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


class RunningDetailView1 extends StatefulWidget {
  final int runningId;

  const RunningDetailView1({
    required this.runningId,
    Key? key}) : super(key: key);

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
  void getRunningDetail(int runningId) async {
    var dio = Dio();
    try {
      print('백에서 러닝상세정보 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io:8081/api/running/detail/$runningId');
      print(response.data);
      setState(() {
        runningDetailId = response.data['runningDetailId'];
        runningDistance = response.data['runningDistance'];
        runningEnd = response.data['runningEnd'];
        runningKcal = response.data['runningKcal'];
        runningPace = response.data['runningPace'];
        runningTime = response.data['runningTime'];
        formattedDate = formatDate(runningEnd);
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
    print('러닝상세정보 조회');
    print(widget.runningId);
    getRunningDetail(widget.runningId);
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
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                    child: runningDetailId == 0 ? SizedBox() :
                    RunningMap(
                      runningDetailId: runningDetailId,
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