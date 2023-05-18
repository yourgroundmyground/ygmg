import 'package:app/const/colors.dart';
import 'package:app/const/state_provider_gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final mediaHeight = MediaQuery.of(context).size.height;

    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    DateTime dateTime1 = DateTime.parse(now);
    DateTime dateTime2 = DateTime.parse(_gameEnd);
    Duration difference = dateTime2.difference(dateTime1);

    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);

    String formattedDifference = '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    List<String> parts = formattedDifference.split(':');
    int rdays = int.parse(parts[0]);
    int rhours = int.parse(parts[1]);
    int rminutes = int.parse(parts[2]);
    int rseconds = int.parse(parts[3]);
    Duration defaultDuration = Duration(days: rdays, hours: rhours, minutes: rminutes, seconds: rseconds);

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
                height: mediaHeight*0.1,
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
                height: mediaHeight*0.1,
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
                height: mediaHeight*0.1,
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
                height: mediaHeight*0.1,
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
