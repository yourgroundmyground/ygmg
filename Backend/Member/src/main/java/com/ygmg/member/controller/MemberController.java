package com.ygmg.member.controller;

import com.ygmg.member.common.auth.CustomUserDetails;
import com.ygmg.member.entity.Member;
import com.ygmg.member.response.UserMypageInfoRes;
import com.ygmg.member.response.UserNickImgRes;
import com.ygmg.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    /**
     * 1. 닉네임 중복체크
     */
    @GetMapping("/check/{nickname}")
    public ResponseEntity<?> nicknameCheck(@PathVariable String nickname){
        Member member = memberService.getMemberByMemberNickname(nickname);
        if (member == null)
            return ResponseEntity.status(200).body("사용가능한 닉네임입니다.");
        else
            return ResponseEntity.status(200).body("중복된 닉네임입니다.");
    }

    /**
     * 2. 이미지, 닉네임 불러오기
     */
    @GetMapping("/me/{memberId}")
    public ResponseEntity<?> nicknameCheck(@PathVariable Long memberId) {
        UserNickImgRes userNickImgRes = memberService.showTopMember(memberId);
        return ResponseEntity.status(200).body(userNickImgRes);
    }

    /**
     * 3. 마이페이지 정보 불러오기
     */
    @GetMapping("/mypage")
    public ResponseEntity<?> showMypage(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Member member = userDetails.getMember();

        UserMypageInfoRes userMypageInfoRes = memberService.mypageInfo(member);

        return ResponseEntity.status(200).body(userMypageInfoRes);
    }

    /**
     * 4. 이미지, 닉네임 불러오기(멤버 리스트)
     */
    @GetMapping("/profiles")
    public ResponseEntity<?> selectMembersProfile(@RequestParam("memberList") List<Long> memberList){

        List<UserNickImgRes> userNickImgRes = memberService.showMemberProfileList(memberList);

        return ResponseEntity.ok(userNickImgRes);
    }
}
