package com.ygmg.game.db.model;

import lombok.Getter;

@Getter
public class RankingData {
    private String gameId;
    private String memberId;
    private double areaSize;
    private int resultRanking;

    public RankingData(String gameId, String memberId) {
        this.gameId = gameId;
        this.memberId = memberId;
    }

    public RankingData(String gameId) {
        this.gameId = gameId;
    }
    public RankingData(int memberId) {
        this.memberId = String.valueOf(memberId);
    }

    public RankingData(double areaSize) {
        this.areaSize = areaSize;
    }

    public void setGameId(String gameId){
        this.gameId = gameId;
    }
    public void setAreaSize(double areaSize){
        this.areaSize = areaSize;
    }

    public int getResultRanking() {
        return resultRanking;
    }

    public void setResultRanking(int resultRanking) {
        this.resultRanking = resultRanking;
    }
}
