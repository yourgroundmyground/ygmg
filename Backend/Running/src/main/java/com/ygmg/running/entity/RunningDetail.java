package com.ygmg.running.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RunningDetail {

    @Id
    private Long id;

    private LocalDateTime runningStart;

    private LocalDateTime runningEnd;

    private Time runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    private Mode runningMode;

    @OneToOne(mappedBy = "running_detail")
    private Running running;

    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL, mappedBy = "running_detail")
    private List<RunningCoordinate> runningCoordinateList = new ArrayList<>();


}
