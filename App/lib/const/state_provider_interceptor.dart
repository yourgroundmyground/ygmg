import 'package:app/const/state_provider_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dio = Dio();

void setupDio(ProviderContainer container) {
  dio.options.baseUrl = 'http://k8c107.p.ssafy.io:8080/api';
  dio.options.connectTimeout = 5000;
  dio.options.receiveTimeout = 5000;

  dio.interceptors.add(TokenInterceptor(container));
}

class TokenInterceptor extends Interceptor {
  final ProviderContainer _container;

  TokenInterceptor(this._container);

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions requestOptions = err.response!.requestOptions;

      final refreshToken = _container.read(userInfoProvider).refreshToken;
      final accessToken = _container.read(userInfoProvider).accessToken;

      if (refreshToken.isEmpty) {
        print('리프레쉬토큰 없음');
        return handler.reject(err);
      }

      var response = await dio.post(
          '/member/reissue',
        data: {
            'authorization':accessToken, 'refreshToken': refreshToken
        }
      );

      TokenInfo newTokenInfo = TokenInfo(
          memberId: _container.read(userInfoProvider).memberId,
          memberNickname: _container.read(userInfoProvider).memberNickname,
          memberWeight: _container.read(userInfoProvider).memberWeight,
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken']);

      _container.read(userInfoProvider.notifier).setUserInfo(newTokenInfo);
      await saveTokenSecureStorage(newTokenInfo);

      requestOptions.headers['Authorization'] = 'Bearer ${newTokenInfo.accessToken}';
      try {
        Response response = await dio.request(
            requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
        );
        print('토큰 재발급. 재발급.');
        handler.resolve(response);
      } catch (e) {
        handler.reject(DioError(requestOptions: requestOptions, error: e));
        print('토큰 재발급 에러');
      }
    } else {
      print('토큰 재발급 시도 에러');
      handler.next(err);
    }
  }
}