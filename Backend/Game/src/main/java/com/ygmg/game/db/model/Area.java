package com.ygmg.game.db.model;

import lombok.*;
import org.hibernate.annotations.DynamicInsert;
import org.locationtech.jts.geom.Coordinate;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
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
    public void makeDonut(Coordinate coordinate, Area area){
        areaCoordinateList.add(AreaCoordinate.builder()
                .areaCoordinateLat(coordinate.x)
                .areaCoordinateLng(coordinate.y)
                .area(area)
                .areaCoordinateTime(LocalDateTime.now(ZoneId.of("Asia/Seoul")))
                .build());
    }


}