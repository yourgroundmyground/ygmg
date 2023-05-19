import 'package:app/const/state_provider_token.dart';
import 'package:dio/dio.dart';

Future<void> fetchGameInfo() async {
  try {
    final response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/gameId');
    final gameId = response.data;
    await storage.write(key: 'gameId', value: gameId.toString());

    final response2 = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/$gameId');
    final gameStart = response2.data['gameStart'];
    final gameEnd = response2.data['gameEnd'];
    await storage.write(key: 'gameStart', value: gameStart);
    await storage.write(key: 'gameEnd', value: gameEnd);

  } catch (e) {
    print('에러 $e');
  }
}


//gameId 호출
Future<int?> getGameId() async {
  final String? gameId = await storage.read(key: 'gameId');
  final String? gameStart = await storage.read(key: 'gameStart');
  final String? gameEnd = await storage.read(key: 'gameEnd');


  return gameId != null ? int.tryParse(gameId) : null;
}

//gateTime 호출
Future<Map<String, String>?> getGameTime() async {
  final String? gameStart = await storage.read(key: 'gameStart');
  final String? gameEnd = await storage.read(key: 'gameEnd');


  if (gameStart != null && gameEnd != null) {
    return {
      'gameStart': gameStart,
      'gameEnd': gameEnd,
    };
  } else {
    return null;
  }
}



Future<void> updateGameId() async {
  try {
    final response = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/gameId');
    final gameId = response.data;
    await storage.write(key: 'gameId', value: gameId.toString());

    final response2 = await Dio().get('https://xofp5xphrk.execute-api.ap-northeast-2.amazonaws.com/ygmg/api/game/$gameId');
    await storage.write(key: 'gameStart', value: response2.data['gameStart']);
    await storage.write(key: 'gameEnd', value: response2.data['gameEnd']);

    print('게임 정보가 업데이트되었습니다.');
  } catch (e) {
    print('에러 $e');
  }
}

