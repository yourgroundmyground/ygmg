package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserNickImgRes {
    private String memberNickname;
    private String profileUrl;
}
