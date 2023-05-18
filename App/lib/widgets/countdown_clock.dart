import 'package:app/const/colors.dart';
import 'package:app/const/state_provider_gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CountDownClock extends StatefulWidget {
  const CountDownClock({Key? key}) : super(key: key);

  @override
  State<CountDownClock> createState() => _CountDownClockState();
}

class _CountDownClockState extends State<CountDownClock> {
  var _gameStart;
  var _gameEnd;

  //게임 시작, 끝 시각 가져오기
  void getGameTimeInfo() async {
    try {
      final gameTimes = await getGameTime();
      final String? gameStart = gameTimes != null ? gameTimes['gameStart'] : null;
      final String? gameEnd = gameTimes != null ? gameTimes['gameEnd'] : null;

      setState(() {
        _gameStart = gameStart;
        _gameEnd = gameEnd;
      });

    } catch (e) {
      print('게임 타임 가져오기 $e');
    }
  }




  @override
  void initState() {
    getGameTimeInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    // final mediaHeight = MediaQuery.of(context).size.height;


    final todaysDate = DateTime.now();
    final gameStartDate = _gameStart != null ? DateTime.parse(_gameStart!) : null;
    final gameEndTime = _gameEnd != null ? DateTime.parse(_gameEnd!) : null;

    //남은 시간
    final remainingTime = gameEndTime?.difference(todaysDate) ?? Duration.zero;


    final remainingDuration = Duration(
      days: remainingTime.inDays,
      hours: remainingTime.inHours.remainder(24),
      minutes: remainingTime.inMinutes.remainder(60),
      seconds: remainingTime.inSeconds.remainder(60),
    );

    final defaultDurationDay = remainingTime.inDays;
    final defaultDurationHour = remainingTime.inHours;
    final defaultDurationMin= remainingTime.inMinutes;
    final defaultDurationSecond = remainingTime.inSeconds;


    // *타이머시간설정
    final defaultDuration = Duration(days: defaultDurationDay, hours: defaultDurationHour, minutes: defaultDurationMin, seconds: defaultDurationSecond);
    print(defaultDuration);
    return Container(
      width: mediaWidth,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: mediaWidth*0.2,
                height: mediaWidth*0.2,
                child: SlideCountdown(
                  padding: EdgeInsets.only(left: 20),
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
                  padding: EdgeInsets.only(left: 20),
                  duration: defaultDuration,
                  decoration: BoxDecoration(
                    color: CLOCK_BLACK,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: mediaWidth*0.08,
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
                  padding: EdgeInsets.only(left: 20),
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
                  padding: EdgeInsets.only(left: 20),
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
