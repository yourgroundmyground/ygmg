import 'dart:convert';
import 'package:app/screens/running/running_start.dart';
import 'package:app/utils/runnning/daily_running_map.dart';
import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const/state_provider_token.dart';
import '../../main.dart';

class DailyRunning extends StatefulWidget {
  final String runningStart;
  final String runningEnd;
  final double runningPace;
  final double runningDist;
  final String runningDuration;
  final double runningKcal;

  const DailyRunning(
      {required this.runningStart,
      required this.runningEnd,
      required this.runningPace,
      required this.runningDist,
      required this.runningDuration,
      required this.runningKcal,
      Key? key})
      : super(key: key);

  @override
  State<DailyRunning> createState() => _DailyRunningState();
}

class _DailyRunningState extends State<DailyRunning> {
  List<Map<String, dynamic>> runninglocationList = [];
  var _tokenInfo;

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  Future<void> _loadRunningData(double runningDist) async {
    SharedPreferences runningResult = await SharedPreferences.getInstance();
    SharedPreferences myTodayGoal = await SharedPreferences.getInstance();
    double? changeDist = myTodayGoal.getDouble('now');
    changeDist ??= 0;
    changeDist += runningDist;
    await myTodayGoal.setDouble('now', changeDist);
    final locationListJson = runningResult.getString('locationList');
    if (locationListJson != null) {
      final locationList = jsonDecode(locationListJson);
      setState(() {
        runninglocationList = List<Map<String, dynamic>>.from(locationList.map((coord) => {'coordinateTime': coord['coordinateTime'], 'lat': coord['lat'], 'lng': coord['lng']}));
      });
    }
  }

  @override
  void initState() {
    _loadTokenInfo().then((_) => {
      _loadRunningData(widget.runningDist).then((value) => sendRunningData())
    });
    super.initState();
  }

  void sendRunningData() async {
    var dio = Dio();
    var data = {
      "coordinateList": runninglocationList,
      "memberId": _tokenInfo.memberId,
      'runningDistance': widget.runningDist,
      "runningEnd": widget.runningEnd,
      'runningKcal': widget.runningKcal,
      'runningPace': widget.runningPace,
      'runningStart': widget.runningStart,
      'runningTime': widget.runningDuration,
    };

    print('만듦');
    print(data);
    try {
      var response = await dio.post('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/running',
          data: data,
        );
      print(response.data);
      SharedPreferences runningResult = await SharedPreferences.getInstance();
      await runningResult.clear();
    } catch (e) {
      print(e.toString());
    }
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
              image: DecorationImage(
                  image: AssetImage('assets/images/runningbgi.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft,
                  repeat: ImageRepeat.noRepeat)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth * 0.07, mediaHeight * 0.05,
                mediaWidth * 0.07, mediaHeight * 0.02),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '나의 달리기 결과',
                      style: TextStyle(
                          fontSize: mediaWidth * 0.08,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()),
                          );
                        },
                        icon: Image.asset('assets/images/closebtn.png'))
                  ],
                ),
                SizedBox(
                  height: mediaHeight * 0.04,
                ),
                Container(
                  width: mediaWidth * 0.7,
                  height: mediaHeight * 0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 28,
                        ),
                      ],
                  ),
                      // image: DecorationImage(
                      //     // 저장한 경로 이미지? 지도?
                      //     image: AssetImage('assets/images/running-gif.gif'),
                      //     fit: BoxFit.fitWidth,
                      //     alignment: Alignment.topLeft,
                      //     repeat: ImageRepeat.noRepeat)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                    child: DailyRunningMap(
                      runninglocationList: runninglocationList
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaHeight * 0.05,
                ),
                GameResultInfo(
                  modalType: 'running',
                  runningTime: widget.runningDuration,
                  runningDist: widget.runningDist,
                  runningKcal: widget.runningKcal,
                  runningPace: widget.runningPace,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
