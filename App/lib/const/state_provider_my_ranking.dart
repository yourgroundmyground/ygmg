import 'package:app/const/state_provider_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyRankingInfo {
  final int memberId;
  final int? rank;
  final double? areaSize;
  final String memberNickname;
  final String profileUrl;

  MyRankingInfo({
    required this.memberId,
    this.rank,
    this.areaSize,
    required this.memberNickname,
    required this.profileUrl,

  });
}

class MyRankingInfoNotifier extends StateNotifier<List<MyRankingInfo>> {
  final Ref ref;

  MyRankingInfoNotifier(this.ref) : super([]);

  Future<List<MyRankingInfo>> fetchMyRankingDataAndSaveState() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    final myId = tokenInfo.memberId;
    print('내아이디 $myId');
    final myNickname = tokenInfo.memberNickname;
    print('내닉네임 $myNickname');


    try {
      //현재 내 순위
      final response = await Dio().get(
          'http://k8c107.p.ssafy.io/api/game/ranking/$myId');
      final data = response.data;
      print('내 게임데이터 $data');

      final response2 = await Dio().get(
          'http://k8c107.p.ssafy.io/api/member/me/$myId');
      final data2 = response2.data;
      print('내 멤버데이터 $data2');

      final myRankingInfo = MyRankingInfo(
          memberId: myId,
          rank: data['rank'],
          areaSize: data['areaSize'],
          memberNickname: myNickname,
          profileUrl: data2['profileUrl'],
      );

      state = [myRankingInfo];
      print('내스테이트 ${state[0].memberNickname}');
      print('내스테이트 ${state[0].memberId}');
      print('내스테이트 ${state[0].rank}');
      print('내스테이트 ${state[0].areaSize}');

      return state;

    } catch (error) {
      print('내 랭킹에러 $error');
      return [];
    }
  }
}

final myRankingInfoProvider = StateNotifierProvider<MyRankingInfoNotifier, List<MyRankingInfo>>(
        (ref) => MyRankingInfoNotifier(ref));

final myRankingInfoFutureProvider = FutureProvider<List<MyRankingInfo>>((ref) async {
  try {
    final myRankingInfoNotifier = ref.watch(myRankingInfoProvider.notifier);
    return await myRankingInfoNotifier.fetchMyRankingDataAndSaveState();
  } catch (e) {
    print(e);
    return [];
  }
});