package com.ygmg.game.db.repository;

import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Ranking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface RankingRepository {

    Set<ZSetOperations.TypedTuple<String>> getTopScores();

    int getRank(String memberId);

    void updateAreaSize(String memberId, double areaSize);
}
