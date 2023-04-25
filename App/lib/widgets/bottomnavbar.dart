import 'package:flutter/material.dart';
import 'package:app/screens/mypage/mypage.dart';
import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/running/running_start.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}
class _NavbarState extends State<Navbar> {
  int _currentIndex = 1;
  List<Widget> _pages = [];
  @override
  void initState() {
    _pages.add(RunningStart());
    _pages.add(Mypage());
    // _pages.add(GameStart()); //게임스타트페이지
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
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
                iconSize: 8,
                selectedFontSize: 4,
                currentIndex: _currentIndex,
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/RunningShoe.png'), label: 'Running'),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/testProfile.png', width: 40,), label: ''),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/b3d37220175f46299a2639f1bf15ded2.png'), label: 'Game')
                ]),
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.blueGrey,
          child: Image.asset('assets/testProfile.png', width: 40,),
          onPressed: () => setState(() {
            _currentIndex = 1;
          }),
        ),
      ),
    );
  }
}