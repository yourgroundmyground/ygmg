package com.ygmg.running.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;


@Getter
@Setter
public class RunningRequest {

    private Long memberId;

    private LocalDateTime runningStart;

    private LocalDateTime runningEnd;

    private LocalTime runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    List<Coordinate> coordinateList = new ArrayList<>();


    @Getter
    public static class Coordinate{
        private Double lat;

        private Double lng;

        private LocalTime coordinateTime;
    }
}
