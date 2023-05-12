import 'package:app/const/state_provider_token.dart';
import 'package:dio/dio.dart';


//토큰인터셉터
class TokenInterceptor extends Interceptor {
  final TokenInfo _tokenInfo;

  TokenInterceptor(this._tokenInfo);

  // TokenInterceptor(TokenInfo tokenInfo) : _tokenInfo = tokenInfo;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    var dio = Dio();

    String accessToken = _tokenInfo.accessToken;
    String refreshToken = _tokenInfo.refreshToken;


    if (err.response?.statusCode == 401) {
      RequestOptions requestOptions = err.response!.requestOptions;

      if (refreshToken.isEmpty) {
        print('리프레쉬토큰 없음');
        return handler.reject(err);
      }

      var response = await dio.post(
          'http://k8c107.p.ssafy.io:8080/api/member/reissue',
        data: {
            'authorization':accessToken,
            'refreshToken': refreshToken
        }
      );

      print('토큰재발급 $response');

      TokenInfo newTokenInfo = TokenInfo(
          memberId: _tokenInfo.memberId,
          memberNickname: _tokenInfo.memberNickname,
          memberWeight: _tokenInfo.memberWeight,
          accessToken: response.data['tokenInfo']['authorization'],
          refreshToken: response.data['tokenInfo']['refreshToken']);


      await saveTokenSecureStorage(newTokenInfo);
      print('토큰저장');

      requestOptions.headers['Authorization'] = 'Bearer ${newTokenInfo.accessToken}';


      try {
        Response response = await dio.request(
          requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
          options: Options(
              headers: requestOptions.headers
          ), //옵션추가
        );
        print('토큰 재발급. 재발급.');
        handler.resolve(response);
      } catch (e) {
        handler.reject(DioError(requestOptions: requestOptions, error: e));
        print('토큰 재발급 에러 $e');
      }
    } else {
      print('401 에러가 아닐 때. 토큰 재발급 시도 에러 $err');
      handler.next(err);
    }
  }
}