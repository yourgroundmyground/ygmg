import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/running/running_start.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}
class _NavbarState extends State<Navbar> {
  int _currentIndex = 2;
  List<Widget> _pages = [];
  @override
  void initState() {
    _pages.add(RunningStart());
    _pages.add(Mypage());
    _pages.add(GameStart()); //게임스타트페이지
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
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white.withOpacity(0),
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
          child: Image.asset('assets/images/testProfile.png', width: 40,),
          ),
          onPressed: () => setState(() {
            _currentIndex = 1;
          }),
        ),
      ),
    );
  }
}