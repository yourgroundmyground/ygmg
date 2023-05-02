package com.ygmg.game.db.repository;

import com.ygmg.game.db.model.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResultRepository extends JpaRepository<Result, Integer> {

    Optional<Result> findByResultId(Integer integer);

    Result save(Result result);

    Optional<Result> findByGameGameIdAndMemberId(int gameId, int memberId);
}
