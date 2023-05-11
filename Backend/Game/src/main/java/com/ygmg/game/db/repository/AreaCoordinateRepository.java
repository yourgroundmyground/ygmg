package com.ygmg.game.db.repository;

import com.ygmg.game.db.model.AreaCoordinate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AreaCoordinateRepository extends JpaRepository<AreaCoordinate, Long> {

    List<AreaCoordinate> findByArea_Id(Long areaId);

    Optional<AreaCoordinate> findById(Long areaCoordinateId);
}
