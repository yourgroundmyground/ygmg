import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenInfo {
  final int memberId;
  final String memberNickname;
  final double memberWeight;
  final String accessToken;
  final String refreshToken;

  TokenInfo({
    required this.memberId,
    required this.memberNickname,
    required this.memberWeight,
    required this.accessToken,
    required this.refreshToken,
  });
}

//상태관리 클래스 생성
class UserInfoNotifier extends StateNotifier<TokenInfo> {
  UserInfoNotifier(): super(
      TokenInfo(
      memberId: 0,
      memberNickname: '',
      memberWeight: 0,
      accessToken: '',
      refreshToken: ''));

  //사용자 정보 업데이트
  void setUserInfo(TokenInfo tokenInfo) {
    state = tokenInfo;
  }

}

//notifier를 관리하는 provider 생성
final userInfoProvider = StateNotifierProvider<UserInfoNotifier, TokenInfo>((ref) => UserInfoNotifier());
final storage = FlutterSecureStorage();



//토큰저장
Future<void> saveTokenSecureStorage(TokenInfo tokenInfo) async {
  await storage.write(key: 'memberId', value: tokenInfo.memberId.toString());
  await storage.write(key: 'memberNickname', value: tokenInfo.memberNickname);
  await storage.write(key: 'memberWeight', value: tokenInfo.memberWeight.toString());
  await storage.write(key: 'accessToken', value: tokenInfo.accessToken);
  await storage.write(key: 'refreshToken', value: tokenInfo.refreshToken);
}

//secure에서 토큰 불러오기
Future<TokenInfo> loadTokenFromSecureStorage() async {
  String? memberId = await storage.read(key: 'memberId');
  String? memberNickname = await storage.read(key: 'memberNickname');
  String? memberWeight = await storage.read(key: 'memberWeight');
  String? accessToken = await storage.read(key: 'accessToken');
  String? refreshToken = await storage.read(key: 'refreshToken');

  memberId = memberId ?? '0';
  memberNickname = memberNickname ?? '';
  memberWeight = memberWeight ?? '0';
  refreshToken = refreshToken ?? '';
  accessToken  = accessToken ?? '' ;

  return TokenInfo(
      memberId: int.parse(memberId),
      memberNickname: memberNickname,
      memberWeight: double.parse(memberWeight),
      accessToken: accessToken,
      refreshToken: refreshToken);

}

