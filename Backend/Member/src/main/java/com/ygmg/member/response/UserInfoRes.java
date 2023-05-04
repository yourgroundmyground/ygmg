package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserInfoRes {
    private String kakaoEmail;
    private String memberBirth;
    private String memberName;
}
