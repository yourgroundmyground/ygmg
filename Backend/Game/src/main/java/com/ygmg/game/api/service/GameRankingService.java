package com.ygmg.game.api.service;

import org.springframework.data.redis.core.ZSetOperations;

import java.util.Set;

public interface GameRankingService {

    void updateAreaSize(String gameId, String memberId, double areaSize);

    void modifyAreaSize(String gameId, String memberId, double areaSize);

    //    List<RankingRes> getRanking();
    Set<ZSetOperations.TypedTuple<String>> getTopScores(String gameId);


    int getRank(String gameId, String memberId);
}
