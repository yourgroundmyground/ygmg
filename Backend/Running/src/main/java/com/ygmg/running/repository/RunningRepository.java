package com.ygmg.running.repository;

import com.ygmg.running.entity.Mode;
import com.ygmg.running.entity.Running;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RunningRepository extends JpaRepository<Running,Long> {

    List<Running> findAllByMemberId(Long memberId);

    List<Running> findByMemberIdAndAndRunningDetail_RunningMode(Long memberId, Mode mode);
}
