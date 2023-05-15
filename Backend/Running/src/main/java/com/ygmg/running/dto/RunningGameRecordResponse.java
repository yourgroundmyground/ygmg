package com.ygmg.running.dto;

import lombok.*;

import java.time.LocalTime;

@Getter
@Setter
@AllArgsConstructor
public class RunningGameRecordResponse {
    // 게임시 달린 시간합, 게임시 평균속도, 게임시 총 달린거리
    private LocalTime time;
    private Double speed;
    private Double distance;
    private Double kcal;

    public void addRecord(LocalTime time, Double speed, Double distance, Double kcal){
        this.time.plusHours(time.getHour());
        this.time.plusMinutes(time.getMinute());
        this.time.plusSeconds(time.getSecond());
        this.speed += speed;
        this.distance += distance;
        this.kcal += kcal;
    }
}
