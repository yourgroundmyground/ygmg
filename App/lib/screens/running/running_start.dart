import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

class RunningStart extends StatelessWidget {
  const RunningStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 오늘 달리기 목표
    double todayGoal = 0.0;
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/runningbgi.png'),
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
                padding: EdgeInsets.fromLTRB(38, 51, 0, 54),
                child: Text('달리기', style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 238,
                    height: 242,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 4,
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
                              fixedSize: Size(217, 217),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150),
                              ),
                              backgroundColor: Color.fromRGBO(255, 255, 255, 0.8)
                          ),
                          child: Text(
                            '목표를 설정해보세요!',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: YGMG_ORANGE
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 94),
              // 목표 입력창
              Container(
                width: 316,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),),
                      Text('${todayGoal.toStringAsFixed(1)} KM',
                        style: TextStyle(
                            fontSize: 20,
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
