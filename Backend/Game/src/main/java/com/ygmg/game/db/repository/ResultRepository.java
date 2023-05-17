package com.ygmg.game.db.repository;

import com.ygmg.game.db.model.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResultRepository extends JpaRepository<Result, Long> {

    Optional<Result> findById(Long resultId);

    Result save(Result result);

    Optional<Result> findByGame_IdAndMemberId(Long gameId, Long memberId);

    List<Result> findByGame_Id(Long gameId);

    @Query(value = "SELECT COUNT(*) FROM result WHERE game_id = :gid", nativeQuery = true)
    Integer getCount(@Param("gid") Long gid);
}
