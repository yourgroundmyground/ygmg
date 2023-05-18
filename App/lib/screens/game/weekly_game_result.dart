import 'package:app/const/state_provider_gameInfo.dart';
import 'package:app/const/state_provider_token.dart';
import 'package:app/widgets/countdown_clock.dart';
import 'package:app/widgets/profile_img.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class WeeklyGameResult extends StatefulWidget {
  const WeeklyGameResult({Key? key}) : super(key: key);

  @override
  State<WeeklyGameResult> createState() => _WeeklyGameResultState();
}

class _WeeklyGameResultState extends State<WeeklyGameResult> {
  var _tokenInfo;
  var runnerCountresult;
  var resultRanking;
  var resultRankingInfoMem;
  var myresultRanking;
  var myResultRankingInfo;

  //이번주 참여한 러너 수 가져오기
  void getRunnersCountResult() async {
    try {
      var response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/result/count');
      print('러너 ${response.data}');

      setState(() {
        runnerCountresult = response.data;
      });
    } catch (e) {
      print('러너 수 가져오기 오류 $e');
    }
  }

  //이번주 랭킹 결과 가져오기
  void getWeeklyRankingResult() async {
    try {
      var thisweekgameId = await getGameId();
      // print('디스윜 $thisweekgameId');

      var response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/result/1'); //여기 결과값 바꿔야함. 이번주 결과가 없어서 오류가 남.

      var resultRankingmem = [response.data[0]['memberId'],response.data[1]['memberId'],response.data[2]['memberId']];
      print(resultRankingmem);
      var memberIds = resultRankingmem.join(',');
      print(memberIds);

      var response2 = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/profiles?memberList=$memberIds');

      setState(() {
        resultRanking = response.data;
        resultRankingInfoMem = response2.data;
      });

    } catch (e) {
      print('이번주결과 가져오기 오류 $e');
    }
  }

  //내 토큰정보
    void _loadTokenInfo() async {
      final tokenInfo = await loadTokenFromSecureStorage();
      var myId = tokenInfo.memberId;
      var thisweekgameId = await getGameId();
      // 여기 수정
      final response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/result/2/$myId'); //여기도 게임아이디 들어감. 수정.
      final response2 = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/me/$myId');

      setState(() {
        myresultRanking = response.data;
        myResultRankingInfo = response2.data;
      });




    }


  //내 랭킹 가져오기
  void getMyWeeklyRankingResult() async {
    try {
      print(_tokenInfo);

    } catch (e) {
      print('내 랭킹가져오기 오류 $e');
    }

  }

  @override
  void initState() {
    _loadTokenInfo();
    super.initState();
    getRunnersCountResult();
    getWeeklyRankingResult();

  }


  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      body: Container(
        width: mediaWidth,
        height: mediaHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/gamemapgj.jpg'),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CountDownClock()
            ),
            const SizedBox(height: 15),
            Flexible(
                flex: 5,
                child: Container(
                    color: Colors.white.withOpacity(0.8),
                    width: mediaWidth * 0.8,
                    height: mediaHeight * 0.6,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: Text(
                                  '총 ${runnerCountresult.toString()}명의 러너가 달렸어요!',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          //랭킹
                          Flexible
                            (
                            flex: 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  child: Userprofile(
                                      height: mediaHeight * 0.06,
                                      width: mediaWidth * 0.75,
                                      imageProvider: NetworkImage(resultRankingInfoMem != null ? resultRankingInfoMem[0]['profileUrl']: ''),
                                      text1: resultRankingInfoMem != null ? resultRanking[0]['resultRanking'].toString() : '',
                                      text2: resultRankingInfoMem != null ? resultRankingInfoMem[0]['memberNickname']: '',
                                      text3: resultRankingInfoMem != null ? (resultRanking[0]['resultArea']*10000000000).toStringAsFixed(0) : '',
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  child: Userprofile(
                                    height: mediaHeight * 0.06,
                                    width: mediaWidth * 0.75,
                                    imageProvider: NetworkImage(resultRankingInfoMem != null ? resultRankingInfoMem[1]['profileUrl']: ''),
                                    text1: resultRankingInfoMem != null ? resultRanking[1]['resultRanking'].toString() : '',
                                    text2: resultRankingInfoMem != null ? resultRankingInfoMem[1]['memberNickname']: '',
                                    text3: resultRankingInfoMem != null ? (resultRanking[1]['resultArea']*10000000000).toStringAsFixed(0) : '',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  child: Userprofile(
                                    height: mediaHeight * 0.06,
                                    width: mediaWidth * 0.75,
                                    imageProvider: NetworkImage(resultRankingInfoMem != null ? resultRankingInfoMem[2]['profileUrl']: ''),
                                    text1: resultRankingInfoMem != null ? resultRanking[2]['resultRanking'].toString() : '',
                                    text2: resultRankingInfoMem != null ? resultRankingInfoMem[2]['memberNickname']: '',
                                    text3: resultRankingInfoMem != null ? (resultRanking[2]['resultArea']*10000000000).toStringAsFixed(0) : '',
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text('이번주 나의 순위'),
                                      const SizedBox(height: 10,),
                                      Userprofile(

                                      imageProvider: NetworkImage(myResultRankingInfo?['profileUrl'] ?? ''),
                                      height: mediaHeight * 0.06,
                                      width: mediaWidth * 0.75,
                                      text1: myresultRanking?['resultRanking']?.toString() ?? '',
                                      text2: myResultRankingInfo?['memberNickname'] ?? '', text3: myresultRanking != null ? myresultRanking['resultArea']?.toString() ?? '' : '',
                                        // text3: myresultRanking?['resultArea']?.toString() ?? '',
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(child: Image.asset('assets/images/Mon_button.png')),
                        ],
                      ),
                    ),

                )
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Navbar(),
    );
  }
}
