package com.ygmg.game.api.response;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RankAndAreaSizeRes {
    int rank;
    double areaSize;

    public RankAndAreaSizeRes(Integer rank, Double areaSize) {
        this.rank = rank;
        this.areaSize = areaSize;
    }

}
