package com.ygmg.member.service;

import com.ygmg.member.entity.Member;

import java.util.HashMap;
import java.util.Optional;

public interface UserService {

    // 카카오 로그인한 정보를 토대로 회원 추가
    void addMember(HashMap<String, Object> userInfo);

    // 이미 로그인한 회원인지 확인
    Optional<Member> findMember(HashMap<String, Object> userInfo);
}
