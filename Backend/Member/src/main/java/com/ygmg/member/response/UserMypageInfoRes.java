package com.ygmg.member.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserMypageInfoRes { // 마이페이지 출력에 필요한 정보
    private String kakaoEmail;
    private String memberBirth;
    private String memberName;
    private String memberNickname;
    private Long memberWeight;
    private String profileImg;
}
