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
import com.ygmg.member.response.UserMypageInfoRes;
import com.ygmg.member.response.UserNickImgRes;
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

    // 회원가입 -> DB 저장
    @Override
    public void joinMember(JoinMemberPostReq joinMemberPostReq, String url) {
        Member member = Member.builder()
                .kakaoEmail(joinMemberPostReq.getKakaoEmail())
                .memberName(joinMemberPostReq.getMemberName())
                .memberBirth(joinMemberPostReq.getMemberBirth())
                .memberNickname(joinMemberPostReq.getMemberNickname())
                .memberWeight(joinMemberPostReq.getMemberWeight())
                .profileUrl(url)
                .build();
        memberRepository.save(member);
    }

    @Override
    public TokenInfo login(JoinMemberPostReq joinMemberPostReq) {
        Member member = memberRepository.findByMemberNickname(joinMemberPostReq.getMemberNickname());
        Long memberId = member.getId();
        Long memberWeight = member.getMemberWeight();

        // 토큰 생성
        String accessToken = jwtTokenUtil.createAccessToken(joinMemberPostReq.getKakaoEmail());
        String refreshToken = jwtTokenUtil.createRefreshToken(joinMemberPostReq.getKakaoEmail());

        // 토큰 info 생성
        TokenInfo tokenInfo = jwtTokenUtil.generateToken(joinMemberPostReq.getMemberNickname(), memberId, memberWeight,accessToken, refreshToken);

        // redis에 저장
        redisRepository.save(new RefreshToken(member.getKakaoEmail(), refreshToken, tokenInfo.getRefreshTokenExpirationTime()));

        return tokenInfo;
    }

    @Override
    public TokenInfo exist(Member member) {
        Long memberId = member.getId();
        Long memberWeight = member.getMemberWeight();

        // 토큰 생성
        String accessToken = jwtTokenUtil.createAccessToken(member.getKakaoEmail());
        String refreshToken = jwtTokenUtil.createRefreshToken(member.getKakaoEmail());

        // 토큰 info 생성
        TokenInfo tokenInfo = jwtTokenUtil.generateToken(member.getMemberNickname(), memberId, memberWeight, accessToken, refreshToken);

        // redis에 저장
        redisRepository.save(new RefreshToken(member.getKakaoEmail(), refreshToken, tokenInfo.getRefreshTokenExpirationTime()));

        return tokenInfo;
    }

    @Override
    public UserMypageInfoRes mypageInfo(Member member) {
        UserMypageInfoRes userMypageInfoRes = UserMypageInfoRes.builder()
                .kakaoEmail(member.getKakaoEmail())
                .memberName(member.getMemberName())
                .memberBirth(member.getMemberBirth())
                .memberNickname(member.getMemberNickname())
                .memberWeight(member.getMemberWeight())
                .profileImg(member.getProfileUrl())
                .build();
        return userMypageInfoRes;
    }

    @Override
    public UserNickImgRes showTopMember(Long memberId) {
        Member member = memberRepository.findById(memberId).get();
        UserNickImgRes userNickImgRes = UserNickImgRes.builder()
                .memberNickname(member.getMemberNickname())
                .profileUrl(member.getProfileUrl())
                .build();
        return userNickImgRes;
    }

    @Override // api요청을 보냈는데 액세스 토큰이 만료됐어. 유효한 토큰인지 검증 후 재발급 과정을 거쳐야함
    public ResponseEntity<?> reissue(UserReissuePostReq userReissuePostReq) {
        if(!jwtTokenUtil.validateToken(userReissuePostReq.getRefreshToken())){ // 먼저 refresh token 검증 -> 만료됐다면?
            return ResponseEntity.status(401).body(UserAuthPostRes.of(401, "Refresh Token 정보가 유효하지 않습니다.",null));
        }
        // 리프레쉬 유효하면? 리프레쉬 토큰으로 회원정보 가져옴
        Authentication authentication = jwtTokenUtil.getAuthentication(userReissuePostReq.getRefreshToken());
        if(!redisRepository.findById(authentication.getName()).get().getRefreshToken().equals(userReissuePostReq.getRefreshToken())){
            return ResponseEntity.status(404).body(UserAuthPostRes.of(404, "RefreshToken 정보가 잘못되었습니다..",null));
        }

        // 토큰에 담아줄 memberNickname과 memberId, memberWeight
        String kakaoEmail = authentication.getName();
        Optional<Member> member = memberRepository.findByKakaoEmail(kakaoEmail);
        Long memberId = member.get().getId();
        String Nickname = member.get().getMemberNickname();
        Long memberWeight = member.get().getMemberWeight();

        // 리프레시 유효한 상황이므로 -> 액세스, 리프레시 두개 재발급
        String accessToken = jwtTokenUtil.createAccessToken(authentication.getName());
        String refreshToken = jwtTokenUtil.createRefreshToken(authentication.getName());
        TokenInfo tokenInfo = jwtTokenUtil.generateToken(Nickname, memberId, memberWeight, accessToken, refreshToken);
        redisRepository.save(new RefreshToken(authentication.getName(), refreshToken ,tokenInfo.getRefreshTokenExpirationTime()));

        return ResponseEntity.ok(UserAuthPostRes.of(200, "Token 정보가 갱신되었습니다.", tokenInfo));
    }
}