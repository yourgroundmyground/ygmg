import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:convert';

void fetchData() async {

  if(await isKakaoTalkInstalled()){

    try{
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
      sendCode(token.accessToken);
    }catch(error){
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);;
        print('카카오계정으로 로그인 성공1 ${token.accessToken}');
        sendCode(token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.login]);
      print('카카오계정으로 로그인 성공2 ${token.accessToken}');
      sendCode(token.accessToken);
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
  // var response = await http.get(Uri.parse("http://192.168.100.114:8080/oauth/go"));
  // // final response = await http.get('url들어갈 자리');
  // print("111111111");
  //
  // if (response.statusCode == 200) {
  //   print("ooooooooooo");
  //   print('Response body: ${response.body}');
  // } else {
  //   print('Request failed with status: ${response.statusCode}.');
  // }

}
void sendCode(var accessToken) async {
  final String baseUrl = "http://192.168.100.114:8080";
  Map<String,String> code = {"accessToken" : accessToken};
  var body = json.encode(code);
  final response = await http.post(Uri.parse(baseUrl + "/oauth/auth/"), headers: {"Content-Type": "application/json"},
      body: body
  );
  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  // 기존 회원가입 유무, id값  -> response로 넘어온다.
  // 기존 회원이라면 액세스 토큰을 우리가 발급해서 주고 메인화면으로 넘어간다.
  // 기존 회원이 아니라면 추가정보 요청페이지로 이동하고 이후 추가정보+id가 다시 백으로 넘어간다.
  // 이후 엑세스토큰이 넘어오면 다시 메인화면으로 넘어간다.
}

// const String kakaoClientId = 'your_kakao_app_client_id';
// const String kakaoClientSecret = 'your_kakao_app_client_secret';
// const String redirectUri = 'your_redirect_uri';
//
// Future<String> getKakaoAccessToken(String code) async {
//   final response = await http.post(Uri.parse('https://kauth.kakao.com/oauth/token'),
//       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//       body: {
//         'grant_type': 'authorization_code',
//         'client_id': "e633b10c3e1c77f0eca01e6abf591367",
//         'client_secret': "oNp9B58UwNT4RppuHG3ZmkVACBAsDP8F",
//         'redirect_uri': "http://localhost:8080/oauth/kakao",
//         'code': code,
//       });
//
//   if (response.statusCode == 200) {
//     final json = jsonDecode(response.body);
//     final accessToken = json['access_token'];
//     return accessToken;
//   } else {
//     throw Exception('Failed to get access token');
//   }
// }

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  onTap: (){
                    //이미지 클릭시 실행할 코드
                    fetchData();
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
