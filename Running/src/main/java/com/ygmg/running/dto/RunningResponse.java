package com.ygmg.running.dto;

import com.ygmg.running.entity.Mode;
import lombok.*;

import java.sql.Time;
import java.time.LocalDateTime;
import java.time.LocalTime;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunningResponse {

    private Long runningDetailId;

    private LocalDateTime runningStart;

    private LocalDateTime runningEnd;

    private LocalTime runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    private String runningMode;

}
