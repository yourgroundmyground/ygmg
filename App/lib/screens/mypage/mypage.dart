import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottomnavbar.dart';
import 'package:app/widgets/runningchart.dart';
import 'package:app/widgets/chart.dart';
import 'package:app/widgets/my_weekly_game.dart';
import 'package:app/utils/map.dart';
import 'package:location/location.dart';


class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);
  @override
  _MypageState createState() => _MypageState();
}
class _MypageState extends State<Mypage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 닉네임
    var nickname = '달려달려';
    // 결과

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
                      borderRadius: BorderRadius.circular(20),
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
                            '안녕하세요, ${nickname} 님!',
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
                      child: Container(
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
                        ),
                        child: Image.asset('assets/images/testProfile.png'),
                      )),
                  Positioned(
                      right: mediaWidth*0.05,
                      top: mediaHeight*0.125,
                      child: Container(
                        child: Image.asset('assets/images/Gear.png'),
                      )),
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
                            Container(
                              child: RunningChart(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          MyWeeklyGame(),
                          MyWeeklyGame(),
                          MyWeeklyGame(),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar:  MapSample(),
    );
  }
}