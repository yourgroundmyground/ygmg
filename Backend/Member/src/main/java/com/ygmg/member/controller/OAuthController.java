package com.ygmg.member.controller;

import com.ygmg.member.common.auth.TokenInfo;
import com.ygmg.member.entity.Member;
import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.response.UserAuthPostRes;
import com.ygmg.member.response.UserInfoRes;
import com.ygmg.member.service.OAuthService;
import com.ygmg.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@Slf4j
@RequestMapping("/api")
@RequiredArgsConstructor
public class OAuthController {

    private final OAuthService oAuthService;

    private final MemberService memberService;

    // 회원가입 요청 -> 6개 정보 들어옴 -> 토큰을 프론트로 넘겨줌
    @PostMapping("/app")
    public ResponseEntity<?> appJoin(@RequestPart(value = "joinMemberPostReq") JoinMemberPostReq joinMemberPostReq, @RequestPart(value = "profile") MultipartFile multipartFile) {

        // 넘어온 6개 정보를 DB에 저장
        memberService.joinMember(joinMemberPostReq);
        TokenInfo tokenInfo = memberService.login(joinMemberPostReq);

        // 프로필 사진 저장
        try {
            byte[] bytes = multipartFile.getBytes();
            FileOutputStream fos = new FileOutputStream("C:\\Users/profileimage.jpg");
            fos.write(bytes);
            fos.close();
            log.info("File uploaded successfully");
        } catch (IOException e) {
            e.printStackTrace();
            log.info("File upload failed");
        }

        log.info("accessToken : " + tokenInfo.getAuthorization());
        log.info("refreshToken : " + tokenInfo.getRefreshToken());
        // 200과 함께 토큰 보내줌
        return ResponseEntity.ok(new UserAuthPostRes().of(200, "Success", tokenInfo));
    }

    @ResponseBody
    @PostMapping("/kakao")
    public ResponseEntity<?> kakaoLogin(@RequestBody Map<String,String> code, HttpSession session){
//        System.out.println("액세스 토큰 : " + code.get("accessToken"));
//        System.out.println(oAuthService.getUserInfo(code.get("accessToken")));

        String access_Token = code.get("accessToken");

        // 받은 access token을 이용하여 사용자 정보를 조회하고, 그 정보를 이용하여 회원가입을 진행하면 된다.
        HashMap<String, Object> userInfo = oAuthService.getUserInfo(access_Token);
        System.out.println("유저 정보는 : " + userInfo);

        // 클라이언트의 이메일이 존재할 때 세션에 해당 이메일과 토큰 등록
        if (userInfo.get("email") != null) {
            session.setAttribute("userId", userInfo.get("email"));
            session.setAttribute("access_Token", access_Token);
        }

        // 기존 가입자 or 비가입자 확인
        Optional<Member> member = memberService.findMember(userInfo);

        // 비가입자라면?
        if(member.equals(Optional.empty())){
            // 가입 처리를 하지말고, UserInfoRes에 담아서 다시 프론트에 ResponseEntity로 보내
            // 카카오 로그인 한 정보를 userInfoRes에 담아서 front에 보낸다.
            UserInfoRes userInfoRes = memberService.sendMemberInfo(userInfo);

            // 기존 회원 X -> 카카오 로그인 정보를 전송
            return ResponseEntity.status(200).body(userInfoRes);
        }
        
        // 기존 가입자라면? -> 로그인 처리 (토큰 유효성 확인)
        else {
            // TODO: 2023-05-04  기존회원 O -> 그냥 토큰만 보내주면 된다

            TokenInfo tokenInfo = memberService.exist(member.get());

            // 200과 함께 토큰 보내줌
            return ResponseEntity.ok(new UserAuthPostRes().of(200, "Success", tokenInfo));
        }

//        return ResponseEntity.status(200).body("kakao 로그인 성공");
    }

    @RequestMapping(value="/logout")
    public String logout(HttpSession session) {
        System.out.println("로그아웃 시작");
        oAuthService.kakaoLogout((String)session.getAttribute("access_Token"));
        session.removeAttribute("access_Token");
        session.removeAttribute("userId");
        System.out.println("로그아웃 끝");
        return "로그아웃됨";
    }
}