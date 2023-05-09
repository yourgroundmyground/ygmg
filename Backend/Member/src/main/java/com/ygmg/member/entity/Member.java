package com.ygmg.member.entity;

import com.ygmg.member.request.JoinMemberPostReq;
import lombok.*;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String kakaoEmail;

    private String memberBirth;

    private String memberNickname;

    private String memberName;

    private Long memberWeight;

    private String profileUrl;
}
