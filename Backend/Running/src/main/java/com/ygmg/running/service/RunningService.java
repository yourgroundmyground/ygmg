package com.ygmg.running.service;

import com.ygmg.running.dto.*;
import com.ygmg.running.entity.Mode;
import com.ygmg.running.entity.RunningCoordinate;

import java.time.LocalDate;

public interface RunningService {

    void saveRunningRecord(RunningRequest runningRequest, Mode mode);

    RunningResponse selectRunningDetail(Long runningId);


    RunningListResponse selectRunningList(Long memberId);

    RunningCoordinateResponse selectRunningCoordinate(Long runningDetailId);

    RunningGameRecordResponse selectSumRunningDetail(Long memberId, String mode ,LocalDate startDate, LocalDate endDate);



}
