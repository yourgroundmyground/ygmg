package com.ygmg.game.db.model;

import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@DynamicInsert
@Getter
@Table(name = "result")
public class Result {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private int resultRanking;

    @Column(nullable = false)
    private double resultArea;

    @Column(nullable = false)
    private Long memberId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name="game_id")
    private Game game; // DB는 오브젝트를 저장할 수 없다. FK, 자바는 오브젝트를 저장할 수 있다.

}