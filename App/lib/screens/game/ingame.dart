import 'package:app/utils/area.dart';
import 'package:app/widgets/profile_img.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'dart:async';
import '../../main.dart';


class InGame extends StatefulWidget {
  const InGame({Key? key}) : super(key: key);
  @override
  State<InGame> createState() => InGameState();
}
class InGameState extends State<InGame> {
  GlobalKey<DrawPolygonState> drawPolygonStateKey = GlobalKey();

  bool isWalking = false;
  bool drawGround = false;
  String currentTime = '';
  String runningStartTime = '';


  void executeCalculate() {
    drawPolygonStateKey.currentState?.calculate();
  }

  void toggleWalking(bool value) {
    setState(() {
      isWalking = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          child: DrawPolygon(
            key: drawPolygonStateKey,
            isWalking: isWalking,
            drawGround: drawGround,
            currentTime: currentTime,
            toggleWalking: toggleWalking,
            runningStartTime: runningStartTime
          ),
        ),
        Positioned(
          left: mediaWidth*0.03,
          top: mediaHeight*0.03,
          child: Container(
            //왼쪽 위 모달
            width: 200,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideCountdown(
                  duration: const Duration(hours: 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFFFDD987),
                            Color(0xFFF79CC3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                  ),
                  onDone: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        // Positioned(
        //     right: mediaWidth*0.03,
        //     top: mediaHeight*0.03,
        //     child: Container(
        //       //오른쪽 위 모달
        //       width: 200,
        //       decoration: BoxDecoration(
        //           color: Colors.white.withOpacity(0.8),
        //           borderRadius: BorderRadius.circular(15)
        //       ),
        //       child: Column(
        //         children: [
        //           Column(
        //             children: [
        //               Text('실시간 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
        //               SizedBox(
        //                 child: Userprofile(
        //                     height: mediaHeight*0.04,
        //                     width: mediaWidth*0.8,
        //                     imageProvider: AssetImage('assets/images/profile01mini.png'),
        //                     text1: '1',
        //                     text2: '군침이싹도나',
        //                     text3: null,
        //                     textStyle: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 15
        //                     )),
        //               ),
        //               SizedBox(
        //                 child: Userprofile(
        //                     height: mediaHeight*0.04,
        //                     width: mediaWidth*0.8,
        //                     imageProvider: AssetImage('assets/images/profile02mini.png'),
        //                     text1: '2',
        //                     text2: '오늘도군것질',
        //                     text3: null,
        //                     textStyle: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 15
        //                     )),
        //               )
        //             ],
        //           ),
        //           Column(
        //             children: [
        //               Text('내 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
        //               SizedBox(
        //                 child: Userprofile(
        //                     height: mediaHeight*0.04,
        //                     width: mediaWidth*0.8,
        //                     imageProvider: AssetImage('assets/images/profilememini.png'),
        //                     text1: '_',
        //                     text2: '가면말티즈',
        //                     text3: null,
        //                     textStyle: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 15
        //                     )),
        //               )
        //             ],
        //           )
        //         ],
        //       ),
        //     )
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFFDD987),
                              Color(0xFFF79CC3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        border: Border.all(
                            color: Colors.white,
                            width: 3
                        )
                    ),
                    child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        onPressed: (){
                          if (!isWalking) {
                            runningStartTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                          }
                          setState(() {
                            isWalking = !isWalking;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFDD987),
                                    Color(0xFFF79CC3),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter
                              ),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 3
                              )
                          ),
                          child : Icon(isWalking ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 45))),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFFDD987),
                              Color(0xFFF79CC3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        border: Border.all(
                            color: Colors.white,
                            width: 3
                        )
                    ),
                    child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        onPressed: (){
                          setState(() {
                            isWalking = !isWalking;
                          });
                          drawPolygonStateKey.currentState?.calculate();
                          drawGround = !drawGround;
                          currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

                        }, child:
                            Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFDD987),
                                          Color(0xFFF79CC3),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter
                                    ),
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 3
                                    )
                                ),
                                child : Icon(Icons.star_border_rounded, size: 45))),
                  ),
                ],
              )
          ),
        ),

      ],
    );
  }
}
