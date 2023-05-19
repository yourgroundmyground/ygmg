import 'dart:async';
import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CountdownTimer extends StatefulWidget {
  final int duration; // 초 단위의 카운트다운 시간

  const CountdownTimer({required this.duration});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  int _remainingTime = 0;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingTime = widget.duration;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progress = _remainingTime / widget.duration;
        } else {
          _timer.cancel();
          showEndModal(); // 시간 종료 시 모달 표시
        }
      });
    });
  }

  void showEndModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('시간 종료'),
          content: Text('게임이 종료되었습니다.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 8,
            valueColor: AlwaysStoppedAnimation<Color>(YGMG_RED),
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
        ),
        Text(
          formatTime(_remainingTime),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
