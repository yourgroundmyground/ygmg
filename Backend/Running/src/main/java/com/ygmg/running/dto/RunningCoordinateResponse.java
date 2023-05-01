package com.ygmg.running.dto;

import lombok.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;



@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunningCoordinateResponse {

    private Long runningDetailId;
    private List<RunningCoordinateDto> runningCoordinateList = new ArrayList<>();

    @Setter
    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RunningCoordinateDto{
        private Double runningLat;

        private Double runningLng;

        private LocalTime coordinateTime;

    }
}
