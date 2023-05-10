package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserNickImgRes {
    private Long memberId;
    private String memberNickname;
    private String profileUrl;
}
