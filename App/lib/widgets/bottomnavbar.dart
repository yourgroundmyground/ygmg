import 'package:app/const/const_isgameEnd.dart';
import 'package:app/const/state_provider_gameInfo.dart';
import 'package:app/screens/game/weekly_game_result.dart';
import 'package:app/screens/game/weekly_game_result_intro.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/running/running_start.dart';
import 'package:dio/dio.dart';
import 'package:app/const/state_provider_interceptor.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}
class _NavbarState extends State<Navbar> {int _currentIndex = 2;
List<Widget> _pages = [];
var _gameStartTime;
var _gameEndTime;
var _isitPlaying = false;
var _isitOver = false;
var _isitFirst = false;
var profileImg;
var _tokenInfo;
final defaultImg = 'assets/images/testProfile.png'; // 기본 이미지 경로

// 회원정보 조회 요청
void getMyPageMember() async {
  var dio = Dio();
  dio.interceptors.add(
      TokenInterceptor(_tokenInfo)
  );

  try {
    var response = await dio.get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/me/${_tokenInfo.memberId}');
    setState(() {
      profileImg = response.data['profileUrl'];
    });
  } catch (e) {
    print(e.toString());
  }
}

//만약 현재 시간이 게임end 시간보다 뒤 && 이번주에 처음 : gameIntro
//만약 현재 시간이 게임end 시간보다 뒤 && 이번주에 재방문 : gameresult

final todaysDate = DateTime.now();

void fetchGameTime() async {
  final gameTimes = await getGameTime();
  final String? gameStart = gameTimes != null ? gameTimes['gameStart'] : null;
  final String? gameEnd = gameTimes != null ? gameTimes['gameEnd'] : null;
  setState(() {
    _gameStartTime = gameStart;
    _gameEndTime = gameEnd;
  });
}

void fetchIsitFirst() async {
  String? isFirstTimeInThisWeek = await isitFisrtTimeInthisWeek();
  if (isFirstTimeInThisWeek == 'false') {
    setState(() {
      _isitFirst = false;
    });
    print('이번 주에 처음이 아닙니다.');
  } else {
    setState(() {
      _isitFirst = true;
    });
    print('이번 주에 처음입니다.');
  }
}

//현재 게임 중인지 여부
void isWithinGameTime() async {
  if (_gameStartTime != null && _gameEndTime != null &&
      todaysDate.isAfter(DateTime.parse(_gameStartTime.toString())) &&
      todaysDate.isBefore(DateTime.parse(_gameEndTime.toString()))) {
    setState(() {
      _isitPlaying = true;
    });
  }
}


//현재 게임이 끝났는지 여부 판단
void isOverGameTime() async {
  if (_gameStartTime != null && _gameEndTime != null &&
      todaysDate.isAfter(DateTime.parse(_gameEndTime.toString()))) {
    setState(() {
      _isitOver = true;
    });
  }
}


@override
void initState() {
  fetchGameTime();
  fetchIsitFirst();
  _pages.add(RunningStart());
  _pages.add(Mypage());


  if (_isitOver == true && _isitFirst == true) { //게임이 끝났고 이번주에 처음일때
    _pages.add(WeeklyGameIntro());
  } else if (_isitOver == true && _isitFirst == false) {//게임이 끝났고 이번주에 처음이 아닐 때
    _pages.add(WeeklyGameResult());
  } else {
    _pages.add(GameStart());
  }

  super.initState();
}
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
                iconSize: 8,
                selectedFontSize: 4,
                currentIndex: _currentIndex,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black.withOpacity(0),
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/images/RunningShoe.png'), label: 'Running'),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/images/testProfile.png', width: 40,), label: ''),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/images/medal.png'), label: 'Game')
                ]),
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child : Container(
            width:  100,
            height: 100,
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
          ),
          child: Image.network(profileImg ?? defaultImg, width: 20),
          ),
          onPressed: () => setState(() {
            _currentIndex = 1;
          }),
        ),
      ),
    );
  }
}