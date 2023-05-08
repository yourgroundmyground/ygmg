package com.ygmg.member.entity;

import com.ygmg.member.request.JoinMemberPostReq;
import lombok.*;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

//    @Column(nullable = false)
    private String kakaoEmail;

//    @Column(nullable = false)
    private String memberBirth;

//    @Column(nullable = false)
    private String memberNickname;

//    @Column(nullable = false)
    private String memberName;

//    @Column(nullable = false)
    private Long memberWeight;

//    @Column(nullable = false)
    private String profileUrl;

}
