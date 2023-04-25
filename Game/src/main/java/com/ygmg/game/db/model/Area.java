package com.ygmg.game.db.model;

import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@DynamicInsert
@Getter
@Table(name = "area")
public class Area {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int areaId;

    @Column(nullable = false)
    private int memberId;

    @Column(nullable = false)
    private LocalDateTime areaDate;

    @Column(nullable = false)
    private double areaSize;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name="gameId")
    private Game game; // DB는 오브젝트를 저장할 수 없다. FK, 자바는 오브젝트를 저장할 수 있다.


}