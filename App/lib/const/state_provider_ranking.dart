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
      final response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/ranking/top/');

      if(response.data is! List<dynamic>) {
        print('랭킹 정보가 존재하지 않습니다.');
        return [];
      }

      final List<dynamic> data = response.data;
      // print('페치 게임데이터 $data');

      final rankerList = data.map((item) => item['memberId']).toList();
      final queryParameters = rankerList.map((memberId) => '$memberId').toList();
      final url = 'https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/member/profiles?memberList=${queryParameters.join(',')}';

      final response2 = await Dio().get(url);

      if(response2.data is! List<dynamic>) {
        print('멤버 정보가 존재하지 않습니다.');
        return [];
      }

      final List<dynamic> data2 = response2.data;
      // print('패치 멤버데이터 ${data2}');

      final rankingInfoList = data.map((item) {
        final memItem = data2.firstWhere((memItem) => memItem['memberId'].toString() == item['memberId'], orElse: () => null);
      //   return RankingInfo(
      //     memberId: item['memberId'],
      //     areaSize: double.tryParse(item['areaSize'].toString()) ?? 0.0,
      //     memberNickname: memItem['memberNickname'],
      //     profileUrl: memItem['profileUrl'],
      //   );
      // }).toList();
        if(memItem == null) {
          print('해당 memberId에 대한 정보가 존재하지 않습니다. memberId: ${item['memberId']}');
          return null;
        }
        return RankingInfo(
          memberId: item['memberId'],
          areaSize: double.tryParse(item['areaSize'].toString()) ?? 0.0,
          memberNickname: memItem['memberNickname'],
          profileUrl: memItem['profileUrl'],
        );
      }).where((rankingInfo) => rankingInfo != null).toList().cast<RankingInfo>();


      state = rankingInfoList;
      return rankingInfoList;

    } catch (error) {
      print('랭킹정보가 존재하지않습니다. $error');
      return [];
    }
  }

}

final rankingInfoProvider = StateNotifierProvider<RankingInfoNotifier, List<RankingInfo>>((ref)  => RankingInfoNotifier(ref));

final rankingInfoFutureProvider = FutureProvider<List<RankingInfo>>((ref) {
  return ref.read(rankingInfoProvider.notifier).fetchRankingDataAndSaveState();
});

