package com.ygmg.game.db.repository;

import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface GameRepository extends JpaRepository<Game, Long> {

    @Query(value = "SELECT id FROM game ORDER BY id DESC LIMIT 1", nativeQuery = true)
    Long findGameId();

    GameRes findGameById(long gameId);
}
