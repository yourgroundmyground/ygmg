package com.ygmg.running.repository;

import com.ygmg.running.entity.RunningDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface RunningDetailRepository extends JpaRepository<RunningDetail, Long> {
}
