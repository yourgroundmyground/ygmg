package com.ygmg.game.api.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
public class AreaCoordinateRegisterPostReq {

    Long memberId;
    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningStart;

    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime runningEnd;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="HH:mm:ss")
    private LocalTime runningTime;

    private Long runningKcal;

    private Double runningDistance;

    private Double runningPace;

    private Long gameId;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime areaDate;

    private double areaSize;


    List<AreaCoordinateDto> areaCoordinateDtoList = new ArrayList<>();






    @AllArgsConstructor
    @RequiredArgsConstructor
    @Getter
    @Setter
    public static class AreaCoordinateDto{
        double areaCoordinateLat;
        double areaCoordinateLng;
        @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
        LocalDateTime areaCoordinateTime;

        Long areaId;
    }

}
