package com.ygmg.member.controller;

import com.ygmg.member.request.JoinMemberPostReq;
import com.ygmg.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.NoSuchElementException;

@RestController
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    /**
     * 1. 닉네임 중복체크
     */
    @GetMapping("/{nickname}")
    public ResponseEntity<?> nicknameCheck(@PathVariable String nickname){
        try {
            memberService.getMemberByMemberNickname(nickname);
        }
        catch (NoSuchElementException e) {
            return ResponseEntity.status(200).body("사용가능한 별명입니다.");
        }
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
     * 3. game에 보내줄 userId
     */


}
