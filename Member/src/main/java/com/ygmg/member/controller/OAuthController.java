package com.ygmg.member.controller;

import com.ygmg.member.service.OAuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

@RestController
@RequestMapping("/oauth")
public class OAuthController {

    @Autowired
    private OAuthService oAuthService;

    @ResponseBody
    @GetMapping("/kakao")
    public void kakaoCallback(@RequestParam String code, HttpSession session) {
        System.out.println(code);
        // code를 이용해 카카오 서버로부터 access token을 받아온다.
        String access_Token = oAuthService.getKakaoAccessToken(code);
        System.out.println("controller access_token : " + access_Token);


        // 받은 access token을 이용하여 사용자 정보를 조회하고, 그 정보를 이용하여 회원가입을 진행하면 된다.
        HashMap<String, Object> userInfo = oAuthService.getUserInfo(access_Token);
        System.out.println("login Controller : " + userInfo);

        //    클라이언트의 이메일이 존재할 때 세션에 해당 이메일과 토큰 등록
        if (userInfo.get("email") != null) {
            session.setAttribute("userId", userInfo.get("email"));
            session.setAttribute("access_Token", access_Token);
        }
    }

    @RequestMapping(value="/logout")
    public String logout(HttpSession session) {
        System.out.println("시작");
        oAuthService.kakaoLogout((String)session.getAttribute("access_Token"));
        session.removeAttribute("access_Token");
        session.removeAttribute("userId");
        System.out.println("끝");
        return "로그아웃됨";
    }

}
