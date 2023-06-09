package com.ygmg.game.api.service;

import com.ygmg.game.db.repository.RankingRepository;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class GameRankingServiceImpl implements GameRankingService {
    private final RankingRepository rankingRepository;

    public GameRankingServiceImpl(RankingRepository rankingRepository){
        this.rankingRepository = rankingRepository;
    }

    @Override
    public void addAreaSize(String gameId, String memberId, double areaSize) {
        rankingRepository.addAreaSize(gameId, memberId, areaSize);
    }

    @Override
    public void modifyAreaSize(String gameId, String memberId, double areaSize) {
        rankingRepository.modifyAreaSize(gameId, memberId, areaSize);
    }

    @Override
    public Set<ZSetOperations.TypedTuple<String>> getTopScores(String gameId) {
        return rankingRepository.getTopScores(gameId);
    }

    @Override
    public int getRank(String gameId, String memberId) {
        return rankingRepository.getRank(gameId, memberId);
    }

    @Override
    public void subAreaSize(String gameId, String memberId, double areaSize) {
        rankingRepository.subAreaSize(gameId, memberId, areaSize);
    }

    @Override
    public int getCount(String gameId) {
        return rankingRepository.getCount(gameId);
    }

    @Override
    public double getAreaSize(String gameId, String memberId) {
        return rankingRepository.getAreaSize(gameId, memberId);
    }
}
