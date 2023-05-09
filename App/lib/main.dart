import 'package:app/const/state_provider_interceptor.dart';
import 'package:app/const/state_provider_token.dart';
import 'package:app/screens/login/loading.dart';
import 'package:app/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'bc0af151df3f9f3634ed6376aa5f3866',
    javaScriptAppKey: 'c59918aaed79bd379c5c09f3fc61be93',
  );
  //토큰 정보 불러오기
  TokenInfo tokenInfo = await loadTokenFromSecureStorage();

  //토큰 값 확인
  print('Loaded accessToken: ${tokenInfo.accessToken}');
  print('Loaded refreshToken: ${tokenInfo.refreshToken}');
  print('Loaded memberId: ${tokenInfo.memberId}');
  print('Loaded memberNickname: ${tokenInfo.memberNickname}');
  print('Loaded memberWeight: ${tokenInfo.memberWeight}');

  //토큰 인터셉터
  final container = ProviderContainer(
    overrides: [
      userInfoProvider.overrideWithProvider(
          StateNotifierProvider<UserInfoNotifier, TokenInfo>(
                  (ref) => UserInfoNotifier()..setUserInfo(tokenInfo)))
    ]
  );

  setupDio(container);
  print('인터셉터');

  runApp(
    ProviderScope(
      overrides: [
        //불러온 토큰 정보 설정
        userInfoProvider.overrideWithProvider(StateNotifierProvider<UserInfoNotifier, TokenInfo>(
                (ref) => UserInfoNotifier()..setUserInfo(tokenInfo)))
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LoadingScreen(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('메인')),
      body: Text(''),
      bottomNavigationBar: Navbar(),
    );
  }
}