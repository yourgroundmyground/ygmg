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
    public void updateAreaSize(String memberId, double areaSize) {
        rankingRepository.updateAreaSize(memberId, areaSize);
    }

    @Override
    public Set<ZSetOperations.TypedTuple<String>> getTopScores() {
        return rankingRepository.getTopScores();
    }

    @Override
    public int getRank(String memberId) {
        return 0;
    }
}
