import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

class RunningStart extends StatelessWidget {
  const RunningStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 오늘 달리기 목표
    double todayGoal = 0.0;
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
              // 이미지 왼쪽 상단 1/4만 표시
              // centerSlice: Rect.fromLTRB(0, 0, 0, 0),
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.white.withOpacity(0.5),
                      //     // spreadRadius: 5,
                      //     blurRadius: 4,
                      //     // offset: Offset(0, 3),
                      //   ),
                      // ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      child: TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(mediaWidth*0.65, mediaWidth*0.65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150),
                              ),
                              backgroundColor: Color.fromRGBO(255, 255, 255, 0.8)
                          ),
                          child: Text(
                            '목표를 설정해보세요!',
                            style: TextStyle(
                                fontSize: mediaWidth*0.06,
                                fontWeight: FontWeight.w700,
                                color: YGMG_ORANGE
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, mediaHeight*0.15),
              ),
              // 목표 입력창
              Container(
                width: mediaWidth*0.8,
                height: mediaWidth*0.17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(mediaWidth*0.08),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('오늘 목표', style: TextStyle(
                          fontSize: mediaWidth*0.05,
                          fontWeight: FontWeight.w600
                      ),),
                      Text('${todayGoal.toStringAsFixed(1)} KM',
                        style: TextStyle(
                            fontSize: mediaWidth*0.055,
                            fontWeight: FontWeight.w600
                        ),)        // *목표미설정시 0.0, 설정 후 변경되도록하기
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: HomePage(),
    );
  }
}
