import 'package:app/const/state_provider_token.dart';
import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  //initState는 await 할 수 없음
  void initState() {
    super.initState();

    // deleteToken();
    checkToken();

  }

  void deleteToken() async {
    await storage.deleteAll();
  }

   void checkToken() async {
    // final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    TokenInfo tokenInfo = await loadTokenFromSecureStorage();

    await Future.delayed(Duration(seconds: 2));

    //토큰 유무에 따라 이동할 페이지 순서
    if (tokenInfo.refreshToken.isEmpty || tokenInfo.accessToken.isEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen(),
          ), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => GameStart()
          ), (route) => false);
    }

   }

  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;


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
