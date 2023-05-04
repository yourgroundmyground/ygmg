import 'dart:convert';
import 'package:app/const/data.dart';
import 'package:app/screens/login/signup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dio dio = Dio();

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
                    // _login();
                    final username = 'test@codefactory.ai';
                    final password = 'testtest';
                    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

                    final resp = await dio.post(
                          'http://10.0.2.2:3000/auth/login',
                          // 'http://192.168.137.1:3000/auth/login',
                          options: Options(
                            headers: {
                              'authorization': basicAuth,
                            },
                          ),
                        );

                    // print(resp);
                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];
                    // final kakaoEmail = resp.data['kakaoEmail'];
                    // final memberBirth = resp.data['memberBirth'];
                    // final memberName = resp.data['memberName'];

                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    // final value22 = await storage.read(key: REFRESH_TOKEN_KEY);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SignUpScreen(
                        // kakaoEmail: kakaoEmail,
                        // memberBirth: memberBirth,
                        // memberName: memberName,
                      ),
                      ),
                    );
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
