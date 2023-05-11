package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class UserInfoRes {
    private String message;
    private String kakaoEmail;
    private String memberBirth;
    private String memberName;
}
