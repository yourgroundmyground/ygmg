package com.ygmg.member.service;

import com.ygmg.member.common.auth.TokenInfo;
import com.ygmg.member.entity.Member;
import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.request.UserReissuePostReq;
import com.ygmg.member.response.UserInfoRes;
import com.ygmg.member.response.UserMypageInfoRes;
import org.springframework.http.ResponseEntity;

import java.util.HashMap;
import java.util.Optional;

public interface MemberService {

    // 카카오 로그인한 정보 프론트에 넘겨줄 Response 객체 생성
    UserInfoRes sendMemberInfo(HashMap<String, Object> userInfo);

    // 기존 회원인지 확인
    Optional<Member> findMember(HashMap<String, Object> userInfo);

    // 닉네임 중복체크
    Member getMemberByMemberNickname(String memberNickname);

    // 회원가입 완료한 유저 회원가입 완료 -> DB에 저장
    void joinMember(JoinMemberPostReq joinMemberPostReq, String url);

    // 첫 회원가입 -> 토큰 전달
    TokenInfo login(JoinMemberPostReq joinMemberPostReq);

    // 기존 회원 -> 토큰 전달
    TokenInfo exist(Member member);

    // 토큰 재발급
    ResponseEntity<?> reissue(UserReissuePostReq userReissuePostReq);

    // 마이페이지 정보조회
    UserMypageInfoRes mypageInfo(Member member);

    Long putUrl(String url);

    void joinMember2(JoinMemberPostReq joinMemberPostReq);
}
