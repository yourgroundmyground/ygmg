package com.ygmg.game.api.service;

import org.springframework.data.redis.core.ZSetOperations;

import java.util.Set;

public interface GameRankingService {

    void updateAreaSize(String memberId, double areaSize);

    //    List<RankingRes> getRanking();
    Set<ZSetOperations.TypedTuple<String>> getTopScores();


    int getRank(String memberId);
}
