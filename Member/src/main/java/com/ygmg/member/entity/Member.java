package com.ygmg.member.entity;

import lombok.*;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

//    @Column(nullable = false)
    private String kakaoEmail;

//    @Column(nullable = false)
    private String memberGender;

//    @Column(nullable = false)
    private String memberBirth;

//    @Column(nullable = false)
    private String memberNickname;

//    @Column(nullable = false)
    private String memberRole;

//    @Column(nullable = false)
    private String memberName;
}
