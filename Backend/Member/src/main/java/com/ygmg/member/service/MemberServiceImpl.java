package com.ygmg.member.service;

import com.ygmg.member.common.auth.TokenInfo;
import com.ygmg.member.common.util.JwtTokenUtil;
import com.ygmg.member.entity.Member;
import com.ygmg.member.entity.RefreshToken;
import com.ygmg.member.repository.MemberRepository;
import com.ygmg.member.repository.RedisRepository;
import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.request.UserReissuePostReq;
import com.ygmg.member.response.UserAuthPostRes;
import com.ygmg.member.response.UserInfoRes;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;
    private final JwtTokenUtil jwtTokenUtil;
    private final RedisRepository redisRepository;
    private final PasswordEncoder passwordEncoder;


    // 카카오 정보 -> DB 저장
//    @Override
//    public void addMember(HashMap<String, Object> userInfo) {
//        Member member = Member.builder()
//                .kakaoEmail((String) userInfo.get("email"))
//                .memberName((String) userInfo.get("name"))
//                .memberBirth((String) userInfo.get("birthday"))
//                .build();
//
//        UserInfoRes userInfoRes = UserInfoRes.builder()
//                .kakaoEmail((String) userInfo.get("email"))
//                .memberName((String) userInfo.get("name"))
//                .memberBirth((String) userInfo.get("birthday"))
//                .build();
//
//        memberRepository.save(member);
//    }

    @Override
    public UserInfoRes sendMemberInfo(HashMap<String, Object> userInfo) {

        UserInfoRes userInfoRes = UserInfoRes.builder()
                .kakaoEmail((String) userInfo.get("email"))
                .memberName((String) userInfo.get("name"))
                .memberBirth((String) userInfo.get("birthday"))
                .build();

        return userInfoRes;
    }


    @Transactional
    @Override
    public Optional<Member> findMember(HashMap<String, Object> userInfo) {
        String email = (String)userInfo.get("email");
        Optional<Member> member = memberRepository.findByKakaoEmail(email);
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
                .kakaoEmail(joinMemberPostReq.getKakaoEmail())
                .memberName(joinMemberPostReq.getMemberName())
                .memberBirth(joinMemberPostReq.getMemberBirth())
                .memberNickname(joinMemberPostReq.getMemberNickname())
                .profileUrl(joinMemberPostReq.getProfileUrl())
                .memberWeight(joinMemberPostReq.getMemberWeight())
                .build();

        memberRepository.save(member);
    }

    @Override
    public TokenInfo login(JoinMemberPostReq joinMemberPostReq) {
        String accessToken = jwtTokenUtil.createAccessToken(joinMemberPostReq.getKakaoEmail());
        String refreshToken = jwtTokenUtil.createRefreshToken(joinMemberPostReq.getKakaoEmail());

        TokenInfo tokenInfo = jwtTokenUtil.generateToken(joinMemberPostReq.getKakaoEmail(), accessToken, refreshToken);

//         redis에 저장
//        redisRepository.save(new RefreshToken(member.getUserEmail(), refreshToken, tokenInfo.getRefreshTokenExpirationTime()));

        return tokenInfo;
    }

    @Override
    public TokenInfo exist(Member member) {

        JoinMemberPostReq joinMemberPostReq = JoinMemberPostReq.builder()
                .kakaoEmail(member.getKakaoEmail())
//                .memberName(member.getMemberName())
//                .memberBirth(member.getMemberBirth())
//                .memberNickname(member.getMemberNickname())
//                .profileUrl(member.getProfileUrl())
//                .memberWeight(member.getMemberWeight())
                .build();

        String accessToken = jwtTokenUtil.createAccessToken(joinMemberPostReq.getKakaoEmail());
        String refreshToken = jwtTokenUtil.createRefreshToken(joinMemberPostReq.getKakaoEmail());

        TokenInfo tokenInfo = jwtTokenUtil.generateToken(joinMemberPostReq.getKakaoEmail(), accessToken, refreshToken);

        // redis에 저장
//        redisRepository.save(new RefreshToken(member.getUserEmail(), refreshToken, tokenInfo.getRefreshTokenExpirationTime()));

        return tokenInfo;
    }


    @Override // api요청을 보냈는데 액세스 토큰이 만료됐어. 그럼 다시 액새스랑 리프레시 재발급 과정을 거쳐야함
    public ResponseEntity<?> reissue(UserReissuePostReq userReissuePostReq) {
        if(!jwtTokenUtil.validateToken(userReissuePostReq.getRefreshToken())){ // 먼저 refresh token 검증 -> 만료됐다면?
            return ResponseEntity.status(401).body(UserAuthPostRes.of(401, "Refresh Token 정보가 유효하지 않습니다.",null));
        }
        // 리프레쉬 유효하면 ? 리프레시 토큰 재발급해줌
        Authentication authentication = jwtTokenUtil.getAuthentication(userReissuePostReq.getRefreshToken());
//        if(!redisRepository.findById(authentication.getName()).get().getRefreshToken().equals(userReissuePostReq.getRefreshToken())){
//            return ResponseEntity.status(404).body(UserAuthPostRes.of(404, "RefreshToken 정보가 잘못되었습니다..",null));
//        }

        // 리프레시 유효한 상황 -> 액세스, 리프레시 두개 재발급
        String accessToken = jwtTokenUtil.createAccessToken(authentication.getName());
        String refreshToken = jwtTokenUtil.createRefreshToken(authentication.getName());
        TokenInfo tokenInfo = jwtTokenUtil.generateToken(authentication.getName(), accessToken, refreshToken);
//        redisRepository.save(new RefreshToken(authentication.getName(), refreshToken ,tokenInfo.getRefreshTokenExpirationTime()));

        return ResponseEntity.ok(UserAuthPostRes.of(200, "Token 정보가 갱신되었습니다.", tokenInfo));
    }

}
