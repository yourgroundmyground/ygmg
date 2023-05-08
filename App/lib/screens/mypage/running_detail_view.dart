import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:dio/dio.dart';


class RunningDetailView1 extends StatefulWidget {
  const RunningDetailView1({Key? key}) : super(key: key);
  @override
  _RunningDetailView1State createState() => _RunningDetailView1State();
}
class _RunningDetailView1State extends State<RunningDetailView1> {
  // GET 요청으로 받아온 데이터를 저장할 변수
  Map<String, dynamic>? runningData;

  // Dio 객체 생성
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
    // GET 요청 보내기
    _fetchRunningData();
  }

  Future<void> _fetchRunningData() async {
    try {
      Response response =
      await dio.get('http://k8c107.p.ssafy.io:8081/api/running/detail/6');
      setState(() {
        List<dynamic> responseData = response.data;
        print(response.data);
        runningData = responseData.length > 0 ? responseData[0] as Map<String, dynamic> : null;
      });
      print('데이터 내놔 ${runningData}');

    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *날짜 변경
    const month = 4;
    const day = 20;
    const time = '10:23AM';

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
                    Text('$month월 $day일 $time',
                      style: TextStyle(
                          fontSize: mediaWidth*0.08,
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
                        }, icon: Image.asset('assets/images/closebtn.png')
                    )
                  ],
                ),
                SizedBox(height: mediaHeight*0.04,),
                Container(
                  width: mediaWidth*0.7,
                  height: mediaHeight*0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mediaWidth*0.02),
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mediaHeight*0.05,),
                GameResultInfo(
                  modalType: 'game',
                  // *여기에 get 으로 받은 데이터를 넣어주세요!
                  runningPace: 0,
                  runningDist: 0,
                  runningKcal: 0,
                  runningTime: 'asdf',
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
