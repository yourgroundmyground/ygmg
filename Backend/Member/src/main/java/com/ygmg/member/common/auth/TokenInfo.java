package com.ygmg.member.common.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class TokenInfo {

    private String userId;
    private String grantType;
    private String authorization;
    private String refreshToken;

    private Long accessTokenExpirationTime;
    private Long refreshTokenExpirationTime;

}
