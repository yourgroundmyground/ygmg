package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserInfoRes {
    String kakaoEmail;
    String memberBirth;
    String memberName;
}
