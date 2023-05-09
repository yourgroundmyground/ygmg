package com.ygmg.member.controller;

import com.ygmg.member.common.auth.TokenInfo;
import com.ygmg.member.entity.Member;
import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.request.UserReissuePostReq;
import com.ygmg.member.response.UserAuthPostRes;
import com.ygmg.member.response.UserInfoRes;
import com.ygmg.member.service.OAuthService;
import com.ygmg.member.service.MemberService;
import com.ygmg.member.service.S3UploaderService;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@Slf4j
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class OAuthController {

    private final OAuthService oAuthService;

    private final MemberService memberService;

    private final S3UploaderService s3UploaderService;

    // 회원가입 요청 -> 6개 정보 들어옴 -> 토큰을 프론트로 넘겨줌
    @PostMapping("/app")
    public ResponseEntity<?> appJoin(@RequestPart(value = "joinMemberPostReq") JoinMemberPostReq joinMemberPostReq, @RequestPart(value = "profile") MultipartFile multipartFile) throws IOException {

        // s3 버킷에 사진 저장
        String url = s3UploaderService.upload(multipartFile, "ygmg", "profile");

        // 6개 파라미터(넘어온 5개 정보 + s3 사진url)을 DB에 저장
        memberService.joinMember(joinMemberPostReq, url);

        // 토큰에 정보 저장
        TokenInfo tokenInfo = memberService.login(joinMemberPostReq);

        // 200과 함께 토큰 보내줌
        return ResponseEntity.ok(new UserAuthPostRes().of(200, "비회원", tokenInfo));
    }

    @ResponseBody
    @PostMapping("/kakao")
    public ResponseEntity<?> kakaoLogin(@RequestBody Map<String,String> code){
        // 카카오에서 준 access_Token
        String access_Token = code.get("accessToken");

        // 받은 access_Token을 이용하여 회원 정보를 조회
        HashMap<String, Object> userInfo = oAuthService.getUserInfo(access_Token);
        System.out.println("유저 정보는 : " + userInfo);

        // 회원 or 비회원 확인
        Optional<Member> member = memberService.findMember(userInfo);

        // 비회원이라면?
        if(member.equals(Optional.empty())){
            System.out.println("비회원");
            // 카카오 로그인 한 정보를 userInfoRes에 담아서 front에 보냄
            UserInfoRes userInfoRes = memberService.sendMemberInfo(userInfo);
            return ResponseEntity.status(200).body(userInfoRes);
        }
        // 회원이라면? -> 로그인 처리
        else {
            System.out.println("회원");
            // TODO: 2023-05-04  기존회원 O -> 그냥 토큰 재발급해서 보내주면 됨
            TokenInfo tokenInfo = memberService.exist(member.get());

            // 200과 함께 토큰 보내줌
            return ResponseEntity.ok(new UserAuthPostRes().of(200, "회원", tokenInfo));
        }
    }

    @PostMapping("/reissue")
    @ApiOperation(value = "토큰 재발급", notes = "<strong>AccessToken,RefreshToken</strong>을 받아 재발급 합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공", response = UserAuthPostRes.class),
            @ApiResponse(code = 401, message = "RefreshToken 유효하지 않음", response = UserAuthPostRes.class),
            @ApiResponse(code = 404, message = "RefreshToken 정보가 잘못되었음", response = UserAuthPostRes.class),
            @ApiResponse(code = 500, message = "서버 오류", response = UserAuthPostRes.class)
    })
    public ResponseEntity<?> reissue(@RequestBody UserReissuePostReq userReissuePostReq){
        return memberService.reissue(userReissuePostReq);
    }
}
