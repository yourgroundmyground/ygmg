package com.ygmg.member.response;

import com.ygmg.member.common.auth.TokenInfo;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

/**
 * 유저 로그인 API ([POST] /api/v1/auth) 요청에 대한 응답값 정의.
 */
@Getter
@Setter
@ApiModel("UserLoginPostResponse")
public class UserAuthPostRes extends BaseResponseBody {
    private TokenInfo tokenInfo;

    public static UserAuthPostRes of(Integer statusCode, String message, TokenInfo tokenInfo) {
        UserAuthPostRes res = new UserAuthPostRes();
        res.setStatusCode(statusCode);
        res.setMessage(message);
        res.tokenInfo = tokenInfo;
        return res;
    }
}
