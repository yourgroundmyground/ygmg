package com.ygmg.game.api.response;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RankingRes {
    String memberId;
    double areaSize;

    public RankingRes(String memberId, Double areaSize) {
        this.memberId = memberId;
        this.areaSize = areaSize;
    }

}
