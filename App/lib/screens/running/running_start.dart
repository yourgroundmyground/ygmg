import 'package:app/const/colors.dart';
import 'package:app/screens/running/in_running.dart';
import 'package:app/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RunningStart extends StatefulWidget {
  const RunningStart({Key? key}) : super(key: key);

  @override
  State<RunningStart> createState() => _RunningStartState();
}

class _RunningStartState extends State<RunningStart> {
  double todayGoal = 0.0;
  String currentDate = '';
  // 현재까지 달린 거리
  double runningDist = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTodayGoal();
  }

  // 첫 렌더링 시 오늘 목표, 진행률 불러오기
  Future<void> _loadTodayGoal() async {
    SharedPreferences myTodayGoal = await SharedPreferences.getInstance();
    double? savedTodayGoal = myTodayGoal.getDouble('todayGoal');
    double? savedNow = myTodayGoal.getDouble('now');
    String? savedCurrentDate = myTodayGoal.getString('currentDate');
    DateTime now = DateTime.now();
    String today = now.toString().substring(0, 10);

    if (savedCurrentDate != today) {
      // currentDate와 저장된 currentDate 값이 다르면
      // 오늘이 아니므로 todayGoal 값을 초기화합니다.
      myTodayGoal.clear();
    } else {
      setState(() {
        runningDist += savedNow ?? 0.0;
        todayGoal = savedTodayGoal ?? 0.0;
        currentDate = savedCurrentDate ?? '';
      });
    }
  }

  // 오늘 목표 저장
  void updateTodayGoal(double newGoal) async {
    DateTime now = DateTime.now();
    String currentDate = now.toString().substring(0, 10);
    SharedPreferences myTodayGoal = await SharedPreferences.getInstance();
    myTodayGoal.setDouble('todayGoal', newGoal);
    myTodayGoal.setString('currentDate', currentDate);
    setState(() {
      todayGoal = newGoal;
    });
  }

  // 목표 설정 모달창
  void showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          modalType: 'goal',
          initialGoal: todayGoal,
        );
      },
    ).then((value) {
      if (value != null) {
        updateTodayGoal(value);
      }
    });
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
              repeat: ImageRepeat.noRepeat,
            )
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, 0, mediaHeight*0.1),
                child: Text('달리기', style: TextStyle(
                    fontSize: mediaWidth*0.07,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: mediaWidth*0.7,
                    height: mediaWidth*0.7,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: mediaWidth*0.01,
                          color: Color.fromRGBO(255, 255, 255, 0.9)
                      ),
                    ),
                  ),
                  Positioned(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InRunning()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(mediaWidth*0.65, mediaWidth*0.65),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(150),
                            ),
                            backgroundColor: Color.fromRGBO(255, 255, 255, 0.8)
                        ),
                        child:
                          todayGoal > 0 ?
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: todayGoal > 0 ? '${runningDist.toStringAsFixed(1)}\n' : '',
                                    style: TextStyle(
                                      fontSize: mediaWidth * 0.15,
                                      fontWeight: FontWeight.w600,
                                      color: YGMG_ORANGE,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/ ${todayGoal.toStringAsFixed(1)} km',
                                    style: TextStyle(
                                      fontSize: mediaWidth * 0.08,
                                      fontWeight: FontWeight.w600,
                                      color: todayGoal > 0 ? YGMG_DARKGREEN : YGMG_ORANGE,
                                    ),
                                  ),
                                ],
                              ),
                            )
                           :
                            Text('목표를 설정해보세요!',
                              style: TextStyle(
                                fontSize: mediaWidth*0.06,
                                fontWeight: FontWeight.w700,
                                color: YGMG_ORANGE
                              )
                            )
                        )
                    ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, mediaHeight*0.15),
              ),
              Container(
                width: mediaWidth*0.8,
                height: mediaWidth*0.17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(mediaWidth*0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    showModal();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('오늘 목표', style: TextStyle(
                            fontSize: mediaWidth*0.05,
                            fontWeight: FontWeight.w600
                        ),),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: todayGoal.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: mediaWidth * 0.06,
                                  fontWeight: FontWeight.w600,
                                  color: todayGoal > 0 ? YGMG_ORANGE : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' KM',
                                style: TextStyle(
                                  fontSize: mediaWidth * 0.055,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ]
                          )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
