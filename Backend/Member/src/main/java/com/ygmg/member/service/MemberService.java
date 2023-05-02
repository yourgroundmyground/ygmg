package com.ygmg.member.service;

import com.ygmg.member.entity.Member;
import com.ygmg.member.request.JoinMemberPostReq;

import java.util.HashMap;
import java.util.Optional;

public interface MemberService {

    // 카카오 로그인한 정보를 토대로 회원 추가
    void addMember(HashMap<String, Object> userInfo);

    // 이미 로그인한 회원인지 확인
    Optional<Member> findMember(HashMap<String, Object> userInfo);

    // 로그인 완료한 유저 닉네임 중복체크
    Member getMemberByMemberNickname(String memberNickname);

    // 로그인 완료한 유저 닉네임/성별/나이 설정 후 회원가입 완료
    void joinMember(JoinMemberPostReq joinMemberPostReq);
}
