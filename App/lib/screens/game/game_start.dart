import 'package:app/const/state_provider_token.dart';
import 'package:app/widgets/countdown_clock.dart';
import 'package:app/widgets/profile_img.dart';
import 'package:flutter/material.dart';


class GameStart extends StatefulWidget {

  @override
  State<GameStart> createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  late TokenInfo? _tokenInfo;



  @override
  void initState() {
    super.initState();
    _loadTokenInfo();
  }

  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    print('멤버아이디 ${_tokenInfo?.memberId}');
    print('멤버닉네임 ${_tokenInfo?.memberNickname}');
    print('멤버몸무게 ${_tokenInfo?.memberWeight}');
    print('액세스토큰 ${_tokenInfo?.accessToken}');
    print('리프레쉬토큰 ${_tokenInfo?.refreshToken}');


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/gamemap.png'),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CountDownClock()),
            Flexible(
                flex: 5,
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  width: mediaWidth*0.8,
                  height: mediaHeight*0.6,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                              '총 ${794}명의 러너가 달리고 있어요!',
                              style: TextStyle(fontSize: 25)),
                        ),
                      ),
                      Flexible
                        (
                        flex: 5,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Userprofile(
                                height: mediaHeight*0.06,
                                width: mediaWidth*0.7,
                                imageProvider: AssetImage('assets/images/profile01.png'),
                                text1: '1',
                                text2: '군침이싹도나',
                                text3: '65081m²',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Userprofile(
                                height: mediaHeight*0.06,
                                width: mediaWidth*0.7,
                                imageProvider: AssetImage('assets/images/profile02.png'),
                                text1: '2',
                                text2: '오늘도군것질',
                                text3: '23564m²',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Userprofile(
                                height: mediaHeight*0.06,
                                width: mediaWidth*0.7,
                                imageProvider: AssetImage('assets/images/profile03.png'),
                                text1: '3',
                                text2: '개발진스땅땅',//flex로 간격 똑같이맞추기
                                text3: '10483m²',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Text('현재 나의 순위'),
                            Userprofile(
                                height: mediaHeight*0.06,
                                width: mediaWidth*0.7,
                                imageProvider: AssetImage('assets/images/profileme.png'),
                                text1: '396',
                                text2: '가면말티즈',
                                text3: '101m²'),
                          ],
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: GestureDetector(
                          onTap: (){},
                          child: Image.asset('assets/images/Startbutton.png'),
                        ),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}