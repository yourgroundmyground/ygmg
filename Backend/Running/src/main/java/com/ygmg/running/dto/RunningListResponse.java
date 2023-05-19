package com.ygmg.running.dto;

import lombok.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModelProperty;
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


    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RunningDto{

        private Long runningId;

        private String runningType;

        private double runningDistance;

        @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
        private LocalDate runningDate;
    }
}
