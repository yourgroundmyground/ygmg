package com.ygmg.running.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.sql.Time;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunningCoordinate {
    @Id
    @GeneratedValue
    private Long id;

    private Double runningLat;

    private Double runningLng;

    private LocalTime coordinateTime;

    @ManyToOne
    @JoinColumn(name="running_detail_id")
    private RunningDetail runningDetail;

}
