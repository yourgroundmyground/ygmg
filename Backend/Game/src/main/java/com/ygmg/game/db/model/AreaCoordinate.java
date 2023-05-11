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
@Table(name = "area_coordinate")
public class AreaCoordinate {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private double areaCoordinateLat;

    @Column(nullable = false)
    private double areaCoordinateLng;

    @Column(nullable = false)
    private LocalDateTime areaCoordinateTime;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name="area_id")
    private Area area; // DB는 오브젝트를 저장할 수 없다. FK, 자바는 오브젝트를 저장할 수 있다.


}