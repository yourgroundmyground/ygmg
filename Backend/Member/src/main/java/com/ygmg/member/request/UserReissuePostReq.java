package com.ygmg.member.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
public class UserReissuePostReq {
    @JsonProperty("authorization")
    private String accessToken;
    @JsonProperty("refreshToken")
    private String refreshToken;
}
