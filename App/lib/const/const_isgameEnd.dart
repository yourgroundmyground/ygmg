import 'package:app/const/state_provider_token.dart';

//이번주에 처음인지 여부 저장
Future<void> setFirstTimeInThisWeek() async {
  await storage.write(key: 'isitFirstTimeInThisWeek', value: 'false');
}

//이번주에 처음인지 여부 확인
Future<String?> isitFisrtTimeInthisWeek() async {
  final intro = await storage.read(key: 'isitFisrtTimeInthisWeek');
  return intro;
}

//주기별로 처음인지 여부 갱신
void resetIsFirstTimeFlag() async {
  //만약 마지막으로 갱신한지 하루이상 지났고, 지금 현재 게임중이라면 갱신

  //하루시간 계산
  const oneWeekInMilliseconds = (24 * 60 * 60 * 1000);

  // 마지막으로 플래그를 재설정한 시간 겟
  final lastResetTimeStr = await storage.read(key: 'lastResetTime');
  final lastResetTime = lastResetTimeStr != null ? int.parse(lastResetTimeStr) : null;

  // 만약 마지막 재설정 시간이 없거나, 주기가 지났다면 플래그 재설정
  if (lastResetTime == null || DateTime.now().millisecondsSinceEpoch - lastResetTime >= oneWeekInMilliseconds) {
    await storage.write(key: 'isitFisrtTimeInthisWeek', value: 'true');
    await storage.write(key: 'lastResetTime', value: DateTime.now().millisecondsSinceEpoch.toString());
  }
}
