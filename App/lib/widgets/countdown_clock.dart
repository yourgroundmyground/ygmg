import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CountDownClock extends StatelessWidget {
  const CountDownClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    // final mediaHeight = MediaQuery.of(context).size.height;
    // *타이머시간설정
    const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Custom BoxDecoration & SeparatorType.title'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: mediaWidth*0.2,
                height: mediaWidth*0.2,
                child: SlideCountdown(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  duration: defaultDuration,
                  decoration: BoxDecoration(
                    color: CLOCK_BLACK,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: mediaWidth*0.08
                  ),
                  shouldShowDays: (p0) => true,
                  shouldShowHours: (p0) => false,
                  shouldShowMinutes: (p0) => false,
                  shouldShowSeconds: (p0) => false,
                ),
              ),
              SizedBox(
                width: 10,
                child: Text(':', textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900
                  ),
                )),
              SizedBox(
                width: mediaWidth*0.2,
                height: mediaWidth*0.2,
                child: SlideCountdown(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  duration: defaultDuration,
                  decoration: BoxDecoration(
                    color: CLOCK_BLACK,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: mediaWidth*0.08
                  ),
                  shouldShowDays: (p0) => false,
                  shouldShowHours: (p0) => true,
                  shouldShowMinutes: (p0) => false,
                  shouldShowSeconds: (p0) => false,
                ),
              ),
              SizedBox(
                  width: 10,
                  child: Text(':', textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w900
                    ),
                  )),
              SizedBox(
                width: mediaWidth*0.2,
                height: mediaWidth*0.2,
                child: SlideCountdown(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  duration: defaultDuration,
                  decoration: BoxDecoration(
                    color: CLOCK_BLACK,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: mediaWidth*0.08
                  ),
                  shouldShowDays: (p0) => false,
                  shouldShowHours: (p0) => false,
                  shouldShowMinutes: (p0) => true,
                  shouldShowSeconds: (p0) => false,
                ),
              ),
              SizedBox(
                  width: 10,
                  child: Text(':', textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900
                    ),
                  )),
              SizedBox(
                width: mediaWidth*0.2,
                height: mediaWidth*0.2,
                child: SlideCountdown(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  duration: defaultDuration,
                  decoration: BoxDecoration(
                    color: CLOCK_BLACK,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: mediaWidth*0.08
                  ),
                  shouldShowDays: (p0) => false,
                  shouldShowHours: (p0) => false,
                  shouldShowMinutes: (p0) => false,
                  shouldShowSeconds: (p0) => true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
