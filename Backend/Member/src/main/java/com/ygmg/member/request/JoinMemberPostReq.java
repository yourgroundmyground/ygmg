package com.ygmg.member.request;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class JoinMemberPostReq {
    private String kakaoEmail;
    private String memberBirth;
    private String memberName;
    private String memberNickname;
    private Long memberWeight;
}
