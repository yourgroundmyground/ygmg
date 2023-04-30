package com.ygmg.member.controller;

import com.ygmg.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<Boolean> nicknameCheck(@PathVariable String nickname){
        try {
            memberService.getMemberByMemberNickname(nickname);
        }
        catch (NoSuchElementException e) {
            return ResponseEntity.status(200).body(true);
        }
        return ResponseEntity.status(200).body(false);
    }
    /**
     * 2. 닉네임, 성별, 나이 보내주는 Request
     */

    /**
     * 3. game에 보내줄 userId
     */


}
