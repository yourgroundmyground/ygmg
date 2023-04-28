package com.ygmg.game.db.model;

import lombok.Getter;

@Getter
public class RankingData {
    private String memberId;
    private double areaSize;

    public RankingData(String memberId, double areaSize) {
        this.memberId = memberId;
        this.areaSize = areaSize;
    }
}
