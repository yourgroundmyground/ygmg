import 'package:app/screens/mypage/mypage.dart';
import 'package:app/widgets/game_result.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GameDetailView1 extends StatefulWidget {
  const GameDetailView1({Key? key}) : super(key: key);
  @override
  _GameDetailView1State createState() => _GameDetailView1State();
}

class _GameDetailView1State extends State<GameDetailView1> {
  // GET 요청으로 받아온 데이터를 저장할 변수
  Map<String, dynamic>? gameData;

  // Dio 객체 생성
  Dio dio = Dio();
햐
  @override
  void initState() {
    super.initState();
    // GET 요청 보내기
    _fetchGameData();
  }

  Future<void> _fetchGameData() async {
    try {
      Response response =
      await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/member/1');
      setState(() {
        List<dynamic> responseData = response.data;
        gameData = responseData.length > 0 ? responseData[0] as Map<String, dynamic> : null;
      });
      print('데이터 내놔 ${gameData}');

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
                SizedBox(
                  height: mediaHeight*0.04,
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

class GameDetailView2 extends StatelessWidget {
  const GameDetailView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *날짜 변경
    const month = 4;
    const day = 21;
    const time = '04:23PM';

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
                SizedBox(
                  height: mediaHeight*0.04,
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
