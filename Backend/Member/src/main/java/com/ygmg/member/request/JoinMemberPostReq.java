package com.ygmg.member.request;

import lombok.Getter;

@Getter
public class JoinMemberPostReq {
    private String memberNickname;
    private String memberGender;
    private Long memberAge;
}
