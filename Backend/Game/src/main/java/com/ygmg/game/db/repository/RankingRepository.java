package com.ygmg.game.db.repository;

import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface RankingRepository {

    Set<ZSetOperations.TypedTuple<String>> getTopScores(String gameId);

    int getRank(String gameId, String memberId);

    void addAreaSize(String gameId, String memberId, double areaSize);

    void modifyAreaSize(String gameId, String memberId, double areaSize);
}
