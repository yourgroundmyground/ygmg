import 'package:flutter/material.dart';

class GameStart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/gamemap.png')
        )
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('게임페이지')),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('시계위젯'),
              SizedBox(
                child: Column(
                  children: [
                    Text('총 794명의 러너가 달리고 있어요'),
                    Text('러너 프로필 Listview로'),
                    Text('현재 나의 순위'),
                    Text('내 프로필'),
                    ElevatedButton(onPressed: (){}, child: Text('땅 차지하러 출발'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}