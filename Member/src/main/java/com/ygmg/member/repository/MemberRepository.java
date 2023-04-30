package com.ygmg.member.repository;

import com.ygmg.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {

    Member findByKakaoEmail(String email);

    Member findByMemberNickname(String memberNickname);
}
