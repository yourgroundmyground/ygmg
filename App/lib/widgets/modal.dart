import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomModal extends StatelessWidget {
  final String modalType;
  final double initialGoal;

  const CustomModal({
    Key? key,
    required this.modalType,
    required this.initialGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _todayGoal = ValueNotifier<double>(initialGoal);
    switch (modalType) {
      case 'goal':
        return RunningGoalModal(
        );
      case 'gameRank':
        return GameRankModal();
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
    // 모달 최종순위
    const finalRank = 10322;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
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


class GameRankModal extends StatelessWidget {
  const GameRankModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 크기
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 모달 최종순위
    const finalRank = 10322;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
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
                            text: '$finalRank ',
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

