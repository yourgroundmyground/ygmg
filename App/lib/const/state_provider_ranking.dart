import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingInfo {
  final String memberId;
  final double areaSize;
  final String memberNickname;
  final String profileUrl;

  RankingInfo({
    required this.memberId,
    required this.areaSize,
    required this.memberNickname,
    required this.profileUrl,

  });
}

class RankingInfoNotifier extends StateNotifier<List<RankingInfo>> {
  final Ref ref;

  RankingInfoNotifier(this.ref): super([]);

  Future<List<RankingInfo>> fetchRankingDataAndSaveState() async {
    try {
      final response = await Dio().get('http://k8c107.p.ssafy.io/api/game/ranking/top/');
      final List<dynamic> data = response.data;
      print('페치 게임데이터 $data');

      final rankerList = data.map((item) => item['memberId']).toList();
      final queryParameters = rankerList.map((memberId) => '$memberId').toList();
      final url = 'http://k8c107.p.ssafy.io/api/member/profiles?memberList=${queryParameters.join(',')}';

      final response2 = await Dio().get(url);
      final List<dynamic> data2 = response2.data;
      print('패치 멤버데이터 ${data2}');

      final rankingInfoList = data.map((item) {
        final memItem = data2.firstWhere((memItem) => memItem['memberId'].toString() == item['memberId'], orElse: () => null);
        return RankingInfo(
          memberId: item['memberId'],
          areaSize: double.tryParse(item['areaSize'].toString()) ?? 0.0,
          memberNickname: memItem['memberNickname'],
          profileUrl: memItem['profileUrl'],
        );
      }).toList();


      state = rankingInfoList;
      print('스테이트 ${state[0].memberNickname}');
      print('스테이트 ${state[0].memberId}');
      print('스테이트 ${state[0].areaSize}');
      print('스테이트 ${state[0].profileUrl}');
      return rankingInfoList;

    } catch (error) {
      print('랭킹에러 $error');
      return [];
    }
  }

}

final rankingInfoProvider = StateNotifierProvider<RankingInfoNotifier, List<RankingInfo>>((ref)  => RankingInfoNotifier(ref));

final rankingInfoFutureProvider = FutureProvider<List<RankingInfo>>((ref) {
  return ref.read(rankingInfoProvider.notifier).fetchRankingDataAndSaveState();
});

