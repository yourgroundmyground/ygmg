package com.ygmg.member.service;

import com.ygmg.member.entity.Member;
import com.ygmg.member.repository.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private MemberRepository memberRepository;

    @Override
    public void addMember(HashMap<String, Object> userInfo) {
        Member member = Member.builder()
                .kakaoEmail((String) userInfo.get("email"))
                .memberNickname((String) userInfo.get("nickname"))
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
}
