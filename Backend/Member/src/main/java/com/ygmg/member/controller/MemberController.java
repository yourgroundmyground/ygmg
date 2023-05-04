package com.ygmg.member.controller;

import com.ygmg.member.common.auth.CustomUserDetails;
import com.ygmg.member.entity.Member;
import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.response.BaseResponseBody;
import com.ygmg.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    /**
     * 1. 닉네임 중복체크
     */
    @GetMapping("/{nickname}")
    public ResponseEntity<?> nicknameCheck(@PathVariable String nickname){
        Member member = memberService.getMemberByMemberNickname(nickname);
        if (member == null)
            return ResponseEntity.status(200).body("사용가능한 별명입니다.");
        else
            return ResponseEntity.status(200).body("중복된 별명입니다.");
    }
    /**
     * 2. 닉네임, 성별, 나이 보내주는 Request
     */
    @PatchMapping("/join")
    public ResponseEntity<?> joinMember(@RequestBody JoinMemberPostReq joinMemberPostReq){
        memberService.joinMember(joinMemberPostReq);
        return ResponseEntity.status(200).body("가입 성공!");
    }
    /**
     * 3. 닉네임 불러오기
     */
    @GetMapping("/me")
    public ResponseEntity<?> logout(@ApiIgnore Authentication authentication) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Member member = userDetails.getMember();

        String nickName = member.getMemberNickname();

        return ResponseEntity.status(200).body(nickName);
    }
}