import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final runnerCountProvider = StateNotifierProvider.autoDispose<RunnerCountNotifier, int>((ref) {
  return RunnerCountNotifier()..getRunners();
});

class RunnerCountNotifier extends StateNotifier<int> {
  RunnerCountNotifier() : super(0);

  Future<void> getRunners() async {
    while(true) {
      try {
        final response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/ranking/count');
        if (response.statusCode == 200) {
          print('러너수 ${response.data}');
          state = response.data;
        } else {
          print('러너카운트 실패');
        }
      } catch (e) {
        print(e);
      }
      await Future.delayed(Duration(seconds: 5)); // 5초마다 러너 수를 업데이트합니다.
    }
  }
}
