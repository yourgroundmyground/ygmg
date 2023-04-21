package com.ygmg.member.entity;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String kakaoEmail;

    @Column(nullable = false)
    private String memberGender;

    @Column(nullable = false)
    private LocalDate memberBirth;

    @Column(nullable = false)
    private String memberNickname;

    @Column(nullable = false)
    private String memberRole;
}
