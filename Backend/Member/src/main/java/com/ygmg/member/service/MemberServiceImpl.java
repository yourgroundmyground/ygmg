package com.ygmg.member.service;

import com.ygmg.member.entity.Member;
import com.ygmg.member.repository.MemberRepository;
import com.ygmg.member.request.JoinMemberPostReq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Optional;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberRepository memberRepository;

    // 카카오 정보 -> DB 저장
    @Override
    public void addMember(HashMap<String, Object> userInfo) {
        Member member = Member.builder()
                .kakaoEmail((String) userInfo.get("email"))
                .memberName((String) userInfo.get("name"))
                .memberBirth((String) userInfo.get("birthday"))
                .build();

        memberRepository.save(member);
    }

    @Transactional
    @Override
    public Optional<Member> findMember(HashMap<String, Object> userInfo) {
        String email = (String)userInfo.get("email");
        Optional<Member> member = Optional.ofNullable(memberRepository.findByKakaoEmail(email));
        return member;
    }

    @Override
    public Member getMemberByMemberNickname(String userNickname) {
        Member member = memberRepository.findByMemberNickname(userNickname);
        System.out.println(member);
        return member;
    }

    // 인게임 정보 -> DB 저장
    @Override
    public void joinMember(JoinMemberPostReq joinMemberPostReq) {

        Member member = Member.builder()
                .memberNickname(joinMemberPostReq.getMemberNickname())
                .memberGender(joinMemberPostReq.getMemberGender())
                .memberAge(joinMemberPostReq.getMemberAge())
                .build();

        memberRepository.save(member);
    }

}
