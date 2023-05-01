package com.ygmg.game.db.repository;

import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AreaRepository extends JpaRepository<Area, Integer> {

    Optional<Area> findByAreaId(int areaId);

    List<Area> findByGameGameId(int gameId);

    List<Area> findByMemberId(int memberId);

    @Transactional
    @Modifying
    @Query(value = "UPDATE Area set areaSize = :modifySize WHERE areaId = :id")
    void updateAreaSize(@Param("id") int id, @Param("modifySize") double modifySize);

    @Query("SELECT a FROM Area a WHERE a.memberId = :memberId AND a.areaDate >= :startDate AND a.areaDate < :endDate")
    List<Area> findByMemberIdAndAreaDate(@Param("memberId") int memberId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

}
