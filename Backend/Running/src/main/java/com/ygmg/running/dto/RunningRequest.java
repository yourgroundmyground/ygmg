package com.ygmg.running.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RunningRequest {

    @ApiModelProperty(example = "회원 아이디")
    private Long memberId;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningStart;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningEnd;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
    private LocalTime runningTime;

    private Double runningKcal;

    private Double runningDistance;

    private Double runningPace;

    List<Coordinate> coordinateList = new ArrayList<>();


    @Getter
    @Setter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Coordinate{
        private Double lat;

        private Double lng;

        @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
        private LocalTime coordinateTime;
    }
}
