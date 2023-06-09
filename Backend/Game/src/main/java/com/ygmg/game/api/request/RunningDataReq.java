package com.ygmg.game.api.request;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RunningDataReq {

    private Long memberId;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningStart;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningEnd;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
    private LocalTime runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    List<RunningDataReq.Coordinate> coordinateList = new ArrayList<>();


    @Getter
    @Builder
    @Setter
    public static class Coordinate{
        private Double lat;

        private Double lng;

        @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
        private LocalTime coordinateTime;
    }
}
