import 'dart:math';
import 'package:app/const/colors.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomModal extends StatelessWidget {
  final String modalType;
  final double? initialGoal;
  final int? weeklyRank;

  const CustomModal({
    Key? key,
    required this.modalType,
    this.initialGoal,
    this.weeklyRank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (modalType) {
      case 'goal':
        return RunningGoalModal(
        );
      case 'gameRank':
        return GameRankModal(
          weeklyRank: weeklyRank!,
        );
      default:
        return Container();
    }     // *현재 페이지가 뭐인지에 따라서 모달이 나오도록 추후에 설정하기
  }
}

class RunningGoalModal extends StatelessWidget {
  final ValueNotifier<double> _todayGoal = ValueNotifier<double>(5.0);
  RunningGoalModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 크기
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
          width: mediaWidth*0.8,
          height: mediaHeight*0.35,
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth*0.08, mediaHeight*0.03, mediaWidth*0.05, mediaHeight*0.03),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('오늘 목표',
                        style: TextStyle(
                            fontSize: mediaWidth*0.05,
                            fontWeight: FontWeight.w700,
                            color: TEXT_GREY,
                            letterSpacing: 2
                        ),
                      ),
                      IconButton(onPressed: () {
                        Navigator.pop(context, _todayGoal.value);
                      }, icon: Icon(Icons.close),
                        iconSize: mediaWidth*0.08,
                      )
                    ]
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, mediaHeight*0.03, 0, 0),
                    child: SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          size: 155,
                          startAngle: 180,
                          angleRange: 180,
                          customWidths: CustomSliderWidths(progressBarWidth: mediaWidth*0.025,
                              trackWidth: mediaWidth*0.01
                          ),
                          customColors: CustomSliderColors(
                            progressBarColors: [YGMG_DARKGREEN, YGMG_GREEN, YGMG_YELLOW],
                            dotColor: YGMG_DARKGREEN,
                            trackColors: [YGMG_DARKGREEN, YGMG_GREEN, YGMG_YELLOW],
                            // dynamicGradient: true,
                          ),
                        ),
                        min: 0.00,
                        max: 15.00,
                        initialValue: _todayGoal.value,
                        onChange: (double value) {
                          // callback providing a value while its being changed (with a pan gesture)
                        },
                        onChangeStart: (double startValue) {
                          // callback providing a starting value (when a pan gesture starts)
                        },
                        onChangeEnd: (double endValue) {
                          _todayGoal.value = endValue;
                          // ucallback providing an ending value (when a pan gesture ends)
                        },
                        innerWidget: (double value) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: mediaWidth * 0.06,
                                    fontWeight: FontWeight.w700,
                                    color: YGMG_ORANGE,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${value.toStringAsFixed(1)} ',
                                    ),
                                    TextSpan(
                                      text: 'km',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                    ),
                  // child: RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w900,
                    //       letterSpacing: 10,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: '$finalRank ',
                    //         style: TextStyle(
                    //           fontSize: mediaWidth * 0.1,
                    //           color: YGMG_RED,
                    //         ),
                    //       ),
                    //       TextSpan(text: '위',
                    //           style: TextStyle(
                    //               fontSize: mediaWidth * 0.06,
                    //               color: Colors.black
                    //           )
                    //       ),
                    //     ],
                    //   ),
                    // )
                )
              ],
            ),
          )
      ),
    );
  }
}


class GameRankModal extends StatefulWidget {
  final int weeklyRank;

  const GameRankModal({
    required this.weeklyRank,
    Key? key}) : super(key: key);

  @override
  State<GameRankModal> createState() => _GameRankModalState();
}

class _GameRankModalState extends State<GameRankModal> {
  late ConfettiController _controllerCenter;

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Path drawRectangle(Size size) {
    final rectWidth = size.width * 0.4;
    final rectHeight = size.height * 0.8;
    final rectLeft = (size.width - rectWidth) / 2;
    final rectTop = (size.height - rectHeight) / 2;

    return Path()
      ..addRect(Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();

    // 10초 후에 confetti 중지
    Future.delayed(Duration(seconds: 10), () {
      _controllerCenter.stop();
    });
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // 미디어 크기
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
          width: mediaWidth*0.8,
          height: mediaHeight*0.25,
          child: Padding(
            padding: EdgeInsets.fromLTRB(mediaWidth*0.08, mediaHeight*0.03, mediaWidth*0.05, mediaHeight*0.03),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('최종 순위',
                        style: TextStyle(
                            fontSize: mediaWidth*0.05,
                            fontWeight: FontWeight.w700,
                            color: TEXT_GREY,
                            letterSpacing: 2
                        ),
                      ),
                      IconButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.close),
                        iconSize: mediaWidth*0.08,
                      )
                    ]
                ),
                Positioned.fill(
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive,
                    gravity: 0.5,
                    shouldLoop:
                    true,
                    colors: const [
                      YGMG_RED,
                      YGMG_ORANGE,
                      YGMG_YELLOW,
                      YGMG_BEIGE,
                      YGMG_GREEN,
                      YGMG_SKYBLUE,
                      YGMG_DARKGREEN,
                      YGMG_PURPLE
                    ],
                    createParticlePath: drawRectangle,
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, mediaHeight*0.03, 0, mediaHeight*0.03),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10,
                        ),
                        children: [
                          TextSpan(
                            text: '${widget.weeklyRank} ',
                            style: TextStyle(
                              fontSize: mediaWidth * 0.1,
                              color: YGMG_RED,
                            ),
                          ),
                          TextSpan(text: '위',
                              style: TextStyle(
                                  fontSize: mediaWidth * 0.06,
                                  color: Colors.black
                              )
                          ),
                        ],
                      ),
                    ))

              ],
            ),
          )
      ),
    );
  }
}

