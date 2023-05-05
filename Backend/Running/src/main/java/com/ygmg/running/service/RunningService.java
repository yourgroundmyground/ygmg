package com.ygmg.running.service;

import com.ygmg.running.dto.RunningCoordinateResponse;
import com.ygmg.running.dto.RunningListResponse;
import com.ygmg.running.dto.RunningRequest;
import com.ygmg.running.dto.RunningResponse;
import com.ygmg.running.entity.Mode;
import com.ygmg.running.entity.RunningCoordinate;

public interface RunningService {

    void saveRunningRecord(RunningRequest runningRequest, Mode mode);

    RunningResponse selectRunningDetail(Long runningId);


    RunningListResponse selectRunningList(Long memberId);

    RunningCoordinateResponse selectRunningCoordinate(Long runningDetailId);

}
