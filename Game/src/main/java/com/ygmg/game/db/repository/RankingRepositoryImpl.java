package com.ygmg.game.db.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public class RankingRepositoryImpl implements RankingRepository{
    private static final String SCORES_KEY = "scores";
    private final RedisTemplate<String, String> redisTemplate;
    @Autowired
    public RankingRepositoryImpl(RedisTemplate<String, String> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    @Override
    public Set<ZSetOperations.TypedTuple<String>> getTopScores() {
        return redisTemplate.opsForZSet().reverseRangeWithScores(SCORES_KEY, 0, 2);
    }

    @Override
    public int getRank(String memberId) {
        return 0;
    }

    @Override
    public void updateAreaSize(String memberId, double areaSize) {
        redisTemplate.opsForZSet().add(SCORES_KEY, memberId, areaSize);
    }
}
