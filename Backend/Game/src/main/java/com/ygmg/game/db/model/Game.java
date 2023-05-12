package com.ygmg.game.db.model;

import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@DynamicInsert
@Getter
@Table(name = "game")
public class Game {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private LocalDateTime gameStart;

    @Column(nullable = false)
    private LocalDateTime gameEnd;

    @Column(nullable = false, length=10)
    private String gamePlace;


    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Area> areaList = new ArrayList<>();
}