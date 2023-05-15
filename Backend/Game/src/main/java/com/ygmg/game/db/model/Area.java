package com.ygmg.game.db.model;

import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@DynamicInsert
@Getter
@Table(name = "area")
public class Area {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long memberId;

    @Column(nullable = false)
    private LocalDateTime areaDate;

    @Column(nullable = false)
    private double areaSize;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name="game_id")
    private Game game;

    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, mappedBy = "area")
    private List<AreaCoordinate> areaCoordinateList = new ArrayList<>();

    public void updateAreaSize(double areaSize){
        this.areaSize = areaSize;
    }


}