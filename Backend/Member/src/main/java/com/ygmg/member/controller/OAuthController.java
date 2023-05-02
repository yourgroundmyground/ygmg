package com.ygmg.member.controller;

import com.ygmg.member.entity.Member;
import com.ygmg.member.service.OAuthService;
import com.ygmg.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/oauth")
public class OAuthController {

    @Autowired
    private OAuthService oAuthService;

    @Autowired
    private MemberService memberService;

    @ResponseBody
    @PostMapping("/auth")
    public String success(@RequestBody Map<String,String> code, HttpSession session){


        System.out.println("액세스 토큰 : "+ code.get("accessToken"));

        System.out.println(oAuthService.getUserInfo(code.get("accessToken")));

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
            // 가입 처리
            memberService.addMember(userInfo);
        }
        // 가입자라면? -> 로그인 처리
        else {

        }

        return code.get("accessToken");
    }

    @ResponseBody
    @GetMapping("/kakao")
    public String kakaoCallback(@RequestParam String code, HttpSession session) {
        System.out.println("코드는? : "+code);
        // code를 이용해 카카오 서버로부터 access token을 받아온다.
        String access_Token = oAuthService.getKakaoAccessToken(code);
        System.out.println("액세스 토큰 : " + access_Token);


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
            // 가입 처리
            memberService.addMember(userInfo);
        }
        // 가입자라면? -> 로그인 처리
        else {

        }

        return "로그인됨";
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

    class Code{
        String accessToken;
    }
}