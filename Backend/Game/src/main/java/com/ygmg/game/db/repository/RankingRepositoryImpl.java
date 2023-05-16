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
    public Set<ZSetOperations.TypedTuple<String>> getTopScores(String gameId) {
        return redisTemplate.opsForZSet().reverseRangeWithScores(gameId, 0, 2);
    }

    @Override
    public int getRank(String gameId, String memberId) {
        Long rank = redisTemplate.opsForZSet().reverseRank(gameId, memberId);
        if (rank == null) {
            // Handle the case where the member does not exist in the ZSet.
            throw new IllegalArgumentException("Member " + memberId + " does not exist in the ZSet");
        }
        // Redis rank starts from 0, so we add 1 to it to make it start from 1.
        return rank.intValue() + 1;
    }

    @Override
    public void addAreaSize(String gameId, String memberId, double areaSize) {
        Double currentScore = redisTemplate.opsForZSet().score(gameId, memberId);
        if (currentScore == null) {
            // If the member does not exist in the ZSet, add it with areaSize as its score.
            redisTemplate.opsForZSet().add(gameId, memberId, areaSize);
        } else {
            // If the member already exists in the ZSet, add areaSize to its current score and update it.
            double newScore = currentScore + areaSize;
            redisTemplate.opsForZSet().add(gameId, memberId, newScore);
        }
    }

    @Override
    public void modifyAreaSize(String gameId, String memberId, double areaSize) {
        redisTemplate.opsForZSet().add(gameId, memberId, areaSize);
    }

    @Override
    public void subAreaSize(String gameId, String memberId, double areaSize) {
        Double currentScore = redisTemplate.opsForZSet().score(gameId, memberId);
        if (currentScore == null) {
            // If the member does not exist in the ZSet, add it with areaSize as its score.
            redisTemplate.opsForZSet().add(gameId, memberId, areaSize);
        } else {
            // If the member already exists in the ZSet, add areaSize to its current score and update it.
            double newScore = currentScore - areaSize;
            redisTemplate.opsForZSet().add(gameId, memberId, newScore);
        }
    }

    @Override
    public int getCount(String gameId) {
        Long count = redisTemplate.opsForZSet().zCard(gameId);
        return count != null ? count.intValue() : 0;
    }
}
