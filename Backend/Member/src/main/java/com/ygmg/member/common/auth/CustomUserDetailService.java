package com.ygmg.member.common.auth;


import java.util.NoSuchElementException;

import com.ygmg.member.entity.Member;
import com.ygmg.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;


/**
 * 현재 액세스 토큰으로 부터 인증된 유저의 상세정보(활성화 여부, 만료, 롤 등) 관련 서비스 정의.
 */
@Component
@RequiredArgsConstructor
public class CustomUserDetailService implements UserDetailsService{


    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("name" + username);
        Member member = memberRepository.findByKakaoEmail(username).orElseThrow(() -> new NoSuchElementException("없는 회원입니다."));
        if(member != null) {
            CustomUserDetails userDetails = new CustomUserDetails(member);
            return userDetails;
        }
        return null;
    }
}
