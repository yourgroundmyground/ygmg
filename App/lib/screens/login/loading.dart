import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    //토큰 유무에 따라 이동할 페이지 순서
    if ('a'=='b' || '엑세스토큰' =='없다') {
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen(),
      ), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => GameStart()
          ), (route) => false);
    }

    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/mainbg.png'),
            ),
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
                margin: EdgeInsets.only(top: mediaHeight*0.05),
                child: Image.asset('assets/images/mainlogo.png')),
        ),
      ),
    );
  }
}
