import 'dart:convert';
import 'package:app/screens/game/game_start.dart';
import 'package:app/screens/login/signup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void fetchData(BuildContext context) async {
  // Dio dio = Dio();
  if(await isKakaoTalkInstalled()){
    try{
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
      sendCode(context, token.accessToken);
    }catch(error){
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
        print('카카오계정으로 로그인 성공1 ${token.accessToken}');
        sendCode(context, token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
      print('카카오계정으로 로그인 성공2 ${token.accessToken}');
      sendCode(context, token.accessToken);
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}

void sendCode(BuildContext context, var accessToken) async {
  print('sndcode 호출됌');
  Dio dio = Dio();
  // final String baseUrl = "http://192.168.100.60:8080"; //ip수정
  Map<String, dynamic> code = {"accessToken" : accessToken};
  // var body = json.encode(code);

    final response = await dio.post(
      "http://k8c107.p.ssafy.io:8080/api/member/kakao",
      options: Options(
          headers: {"Content-Type": "application/json"}),
      data: jsonEncode(code),
    );
    if (response.statusCode == 200) {

      //비회원일 때
      if (response.data['message'] == '비회원') {
        final String kakaoEmail = response.data['kakaoEmail'];
        final String memberBirth = response.data['memberBirth'];
        final String memberName = response.data['memberName'];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SignUpScreen(
                  kakaoEmail: kakaoEmail,
                  memberBirth: memberBirth,
                  memberName: memberName,
                ),
          ),
        );
      } else { //회원일때
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                GameStart()
          ),
        );
      }
      print('Response body: ${response.data}');

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dio dio = Dio();

    final mediaWidth = MediaQuery.of(context).size.width;
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: mediaHeight*0.05),
                  child: Image.asset('assets/images/mainlogo.png')),
              Container(
                margin: EdgeInsets.only(top: mediaHeight*0.02),
                child: GestureDetector(
                  onTap: () async {
                    //이미지 클릭시 실행할 코드
                    fetchData(context);

                    print('터치터치');
                  },
                  child: Image.asset('assets/images/kakao_login_medium_wide.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      //이미지 클릭시 실행할 코드

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: mediaWidth*0.4),
                      margin: EdgeInsets.only(top: mediaHeight*0.01),
                      child: Text('니땅내땅이 처음이세요?',
                          style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
                    )),
                ]),
              ]
            ),
          ),
        );
  }
}
