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
    @GeneratedValue
    private Long id;

    private LocalDateTime runningStart;

    private LocalDateTime runningEnd;

    private Time runningTime;

    private Double runningKcal;

    private Double runningDistance;

    private Double runningPace;

    @Enumerated(value = EnumType.STRING)
    private Mode runningMode;

    @OneToOne
    @JoinColumn(name = "running_id")
    private Running running;

    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL, mappedBy = "runningDetail")
    private List<RunningCoordinate> runningCoordinateList = new ArrayList<>();

    public void saveRunning(Running running){
        this.running = running;
    }

}
