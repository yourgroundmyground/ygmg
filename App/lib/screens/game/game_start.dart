import 'package:app/const/state_provider_ranking.dart';
import 'package:app/widgets/countdown_clock.dart';
import 'package:app/widgets/profile_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameStart extends ConsumerWidget {

  GameStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    final rankingInfoAsyncValue = ref.watch(rankingInfoFutureProvider);

    return rankingInfoAsyncValue.when(
      data: (rankingInfoList) {
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
                                    // imageProvider: AssetImage('assets/images/profile01.png'),
                                    imageProvider: NetworkImage(rankingInfoList.length > 0 ? rankingInfoList[0].profileUrl : ''),
                                    text1: rankingInfoList.length > 0 ? '1' : '',
                                    text2: rankingInfoList.length > 0 ? rankingInfoList[0].memberNickname.toString() : '',
                                    text3: rankingInfoList.length > 0 ? rankingInfoList[0].areaSize.toString() : '',
                                    // text2: rankingInfoList[0].memberNickname.toString(),
                                    // text3: rankingInfoList[0].areaSize.toString(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Userprofile(
                                    height: mediaHeight*0.06,
                                    width: mediaWidth*0.7,
                                    // imageProvider: AssetImage('assets/images/profile02.png'),
                                    imageProvider: NetworkImage(rankingInfoList.length > 1 ? rankingInfoList[1].profileUrl : ''),

                                    text1: rankingInfoList.length > 1 ? '2' : '',
                                    text2: rankingInfoList.length > 1 ? rankingInfoList[1].memberNickname : '',
                                    text3: rankingInfoList.length > 1 ? rankingInfoList[1].areaSize.toString() : '',

                                    // text2: rankingInfoList.length > 1 ? rankingInfoList[1].memberNickname.toString() : '',
                                    // text3: rankingList[1]?.areaSize.toString(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Userprofile(
                                    height: mediaHeight*0.06,
                                    width: mediaWidth*0.7,
                                    imageProvider: NetworkImage(rankingInfoList.length > 2 ? rankingInfoList[2].profileUrl : ''),
                                    text1: rankingInfoList.length > 2 ? '3': '',
                                    text2: rankingInfoList.length > 2 ? rankingInfoList[2].memberNickname : '',
                                    text3: rankingInfoList.length > 2 ? rankingInfoList[2].areaSize.toString(): '',
                                    // imageProvider: AssetImage('assets/images/profile03.png'),
                                    // text3: rankingInfoList.length > 2 ? rankingInfoList[2].areaSize.toString() : '',

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
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );

    //
    // return Scaffold(
    //   body: Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     decoration: BoxDecoration(
    //         image: DecorationImage(
    //           fit: BoxFit.cover,
    //           image: AssetImage('assets/images/gamemap.png'),
    //         )
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Flexible(
    //             flex: 1,
    //             fit: FlexFit.tight,
    //             child: CountDownClock()),
    //         Flexible(
    //             flex: 5,
    //             child: Container(
    //               color: Colors.white.withOpacity(0.8),
    //               width: mediaWidth*0.8,
    //               height: mediaHeight*0.6,
    //               child: Column(
    //                 children: [
    //                   Flexible(
    //                     flex: 2,
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 15),
    //                       child: Text(
    //                           '총 ${794}명의 러너가 달리고 있어요!',
    //                           style: TextStyle(fontSize: 25)),
    //                     ),
    //                   ),
    //                   Flexible
    //                     (
    //                     flex: 5,
    //                     child: Column(
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(vertical: 4),
    //                           child: Userprofile(
    //                             height: mediaHeight*0.06,
    //                             width: mediaWidth*0.7,
    //                             imageProvider: AssetImage('assets/images/profile01.png'),
    //                             text1: '1',
    //                             text2: '군침이싹도나',
    //                             // text3: rankerInfoGame.isEmpty
    //                             //     ? CircularProgressIndicator()
    //                             //     : rankerInfoGame[0].areaSize.toString(),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
    //                           child: Userprofile(
    //                             height: mediaHeight*0.06,
    //                             width: mediaWidth*0.7,
    //                             imageProvider: AssetImage('assets/images/profile02.png'),
    //                             text1: '2',
    //                             text2: '오늘도군것질',
    //                             // text3: rankingList[1]?.areaSize.toString(),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
    //                           child: Userprofile(
    //                             height: mediaHeight*0.06,
    //                             width: mediaWidth*0.7,
    //                             imageProvider: AssetImage('assets/images/profile03.png'),
    //                             text1: '3',
    //                             text2: '개발진스땅땅',//flex로 간격 똑같이맞추기
    //                             // text3: rankingList[2]?.areaSize.toString(),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Flexible(
    //                     flex: 2,
    //                     child: Column(
    //                       children: [
    //                         Text('현재 나의 순위'),
    //                         Userprofile(
    //                             height: mediaHeight*0.06,
    //                             width: mediaWidth*0.7,
    //                             imageProvider: AssetImage('assets/images/profileme.png'),
    //                             text1: '396',
    //                             text2: '가면말티즈',
    //                             text3: '101m²'),
    //                       ],
    //                     ),
    //                   ),
    //                   Flexible(
    //                     fit: FlexFit.tight,
    //                     flex: 2,
    //                     child: GestureDetector(
    //                       onTap: (){},
    //                       child: Image.asset('assets/images/Startbutton.png'),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             )
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
