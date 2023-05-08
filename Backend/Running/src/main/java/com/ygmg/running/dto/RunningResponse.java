package com.ygmg.running.dto;

import com.ygmg.running.entity.Mode;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonFormat;
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

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningStart;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningEnd;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
    private LocalTime runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    private String runningMode;

}
