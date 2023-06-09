import 'package:app/const/state_provider_gameInfo.dart';
import 'package:app/const/state_provider_interceptor.dart';
import 'package:app/const/state_provider_my_ranking.dart';
import 'package:app/const/state_provider_ranking.dart';
import 'package:app/const/state_provider_token.dart';
import 'package:app/screens/login/loading.dart';
import 'package:app/widgets/bottomnavbar.dart';
import 'package:dio/dio.dart';
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

  Dio dio = Dio();
  dio.interceptors.add(TokenInterceptor(tokenInfo));

  //토큰 값 확인
  if (tokenInfo.accessToken.isNotEmpty && tokenInfo.refreshToken.isNotEmpty) {
    // print('메인 accessToken: ${tokenInfo.accessToken}');
    // print('메인 refreshToken: ${tokenInfo.refreshToken}');
    // print('메인 memberId: ${tokenInfo.memberId}');
    // print('메인 memberNickname: ${tokenInfo.memberNickname}');
    // print('메인 memberWeight: ${tokenInfo.memberWeight}');
  } else {
    tokenInfo = TokenInfo(
        memberId: 0,
        memberNickname: '',
        memberWeight: 0,
        accessToken: '',
        refreshToken: ''
    );
  }

  fetchGameInfo();
  updateGameId();


  final gameTimes = await getGameTime();
  final String? gameStart = gameTimes != null ? gameTimes['gameStart'] : null;
  final String? gameEnd = gameTimes != null ? gameTimes['gameEnd'] : null;

  final TodaysDate = DateTime.now();





  runApp(
    ProviderScope(
      overrides: [
        //유저 정보 상태관리를 위한 프로바이더 설정
        userInfoProvider.overrideWithProvider(StateNotifierProvider<UserInfoNotifier, TokenInfo>(
                (ref) => UserInfoNotifier()..setUserInfo(tokenInfo))),
        //랭킹 정보 상태관리를 위한 프로바이더 설정
        rankingInfoProvider.overrideWithProvider(StateNotifierProvider<RankingInfoNotifier, List<RankingInfo>>(
                (ref) => RankingInfoNotifier(ref))),
        //내 랭킹 정보 상태관리를 위한 프로바이더 설정
        myRankingInfoProvider.overrideWithProvider(StateNotifierProvider<MyRankingInfoNotifier, List<MyRankingInfo>>(
                (ref) => MyRankingInfoNotifier(ref))),
      ],
      child: MyApp(
        gameStart:gameStart,
        gameEnd: gameEnd,
        todaysDate: TodaysDate,
      ),
    )
  );
}

class MyApp extends StatelessWidget{
  final String? gameStart;
  final String? gameEnd;
  final DateTime todaysDate;

  MyApp({
    required this.gameStart,
    required this.gameEnd,
    required this.todaysDate,
  });

  @override
  Widget build(BuildContext context) {
    final isWithinGameTime = gameStart != null &&
        gameEnd != null &&
        todaysDate.isAfter(DateTime.parse(gameStart.toString())) &&
        todaysDate.isBefore(DateTime.parse(gameEnd.toString()));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LoadingScreen() ,

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