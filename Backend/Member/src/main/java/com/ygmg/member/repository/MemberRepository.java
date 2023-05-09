package com.ygmg.member.repository;

import com.ygmg.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Map;
import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {

    Optional<Member> findByKakaoEmail(String email);

    Member findByMemberNickname(String memberNickname);
}
