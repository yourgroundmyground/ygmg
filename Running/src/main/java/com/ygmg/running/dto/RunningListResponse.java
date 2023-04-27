package com.ygmg.running.dto;

import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunningListResponse {

    private Long memberId;

    private List<RunningDto> runningList = new ArrayList<>();


    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RunningDto{

        private Long runningId;

        private LocalDate runningDate;
    }
}
