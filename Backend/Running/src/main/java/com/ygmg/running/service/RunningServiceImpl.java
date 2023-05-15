package com.ygmg.running.service;

import com.ygmg.running.dto.*;
import com.ygmg.running.entity.Mode;
import com.ygmg.running.entity.Running;
import com.ygmg.running.entity.RunningCoordinate;
import com.ygmg.running.entity.RunningDetail;
import com.ygmg.running.repository.RunningDetailRepository;
import com.ygmg.running.repository.RunningRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;


@Service
@Slf4j
@RequiredArgsConstructor
public class RunningServiceImpl implements RunningService{

    private final RunningRepository runningRepository;

    private final RunningDetailRepository runningDetailRepository;

    @Override
    @Transactional
    public void saveRunningRecord(RunningRequest runningRequest, Mode mode) {


        List<RunningCoordinate> list = new ArrayList<>();

        RunningDetail runningDetail = RunningDetail.builder()
                .runningStart(runningRequest.getRunningStart())
                .runningEnd(runningRequest.getRunningEnd())
                .runningKcal(runningRequest.getRunningKcal())
                .runningDistance(runningRequest.getRunningDistance())
                .runningPace(runningRequest.getRunningPace())
                .runningTime(Time.valueOf(runningRequest.getRunningTime()))
                .runningMode(mode)
                .runningCoordinateList(list)
                .build();

        for(RunningRequest.Coordinate coordinate : runningRequest.getCoordinateList()){
            list.add(RunningCoordinate.builder()
                    .runningLat(coordinate.getLat())
                    .runningLng(coordinate.getLng())
                    .coordinateTime(coordinate.getCoordinateTime())
                    .runningDetail(runningDetail)
                    .build());
        }

        Running running = Running.builder()
                .runningDate(runningRequest.getRunningStart().toLocalDate())
                .memberId(runningRequest.getMemberId())
                .runningDetail(runningDetail)
                .build();

        runningDetail.saveRunning(running);

        runningRepository.save(running);
    }

    @Override
    public RunningResponse selectRunningDetail(Long runningId) {
        Running running = runningRepository.findById(runningId).get();

        RunningResponse runningResponse = RunningResponse.builder()
                .runningDetailId(running.getRunningDetail().getId())
                .runningStart(running.getRunningDetail().getRunningStart())
                .runningEnd(running.getRunningDetail().getRunningEnd())
                .runningKcal(running.getRunningDetail().getRunningKcal())
                .runningDistance(running.getRunningDetail().getRunningDistance())
                .runningPace(running.getRunningDetail().getRunningPace())
                .runningTime(running.getRunningDetail().getRunningTime().toLocalTime())
                .runningMode(running.getRunningDetail().getRunningMode().toString())
                .build();

        return runningResponse;
    }

    @Override
    public RunningListResponse selectRunningList(Long memberId) {

        List<Running> runningList = runningRepository.findAllByMemberId(memberId);

        RunningListResponse runningListResponse = new RunningListResponse();
        List<RunningListResponse.RunningDto> runningDtoList = new ArrayList<>();
        runningListResponse.setMemberId(memberId);
        for(Running running : runningList){

            RunningListResponse.RunningDto runningDto = RunningListResponse.RunningDto.builder()
                    .runningDate(running.getRunningDate())
                    .runningType(running.getRunningDetail().getRunningMode().toString())
                    .runningDistance(running.getRunningDetail().getRunningDistance())
                    .runningId(running.getId())
                    .build();

            runningDtoList.add(runningDto);
        }
        runningListResponse.setRunningList(runningDtoList);


        return runningListResponse;

    }

    @Override
    public RunningCoordinateResponse selectRunningCoordinate(Long runningDetailId) {


        RunningCoordinateResponse runningCoordinateResponse = new RunningCoordinateResponse();

        runningCoordinateResponse.setRunningDetailId(runningDetailId);

        List<RunningCoordinateResponse.RunningCoordinateDto> runningCoordinateDtoList = new ArrayList<>();

        RunningDetail runningDetail = runningDetailRepository.findById(runningDetailId).get();
        for(RunningCoordinate runningCoordinate : runningDetail.getRunningCoordinateList()){

            RunningCoordinateResponse.RunningCoordinateDto runningCoordinateDto = RunningCoordinateResponse.RunningCoordinateDto.builder()
                    .runningLat(runningCoordinate.getRunningLat())
                    .runningLng(runningCoordinate.getRunningLng())
                    .coordinateTime(runningCoordinate.getCoordinateTime())
                    .build();

            runningCoordinateDtoList.add(runningCoordinateDto);
        }

        runningCoordinateResponse.setRunningCoordinateList(runningCoordinateDtoList);


        return runningCoordinateResponse;
    }

    @Override
    public RunningGameRecordResponse selectGameRunningDetail(Long memberId, LocalDate gameStartDate, LocalDate gameEndDate) {
        List<Running> runningList = runningRepository.findAllByMemberId(memberId);
        RunningGameRecordResponse runningGameRecordResponse = new RunningGameRecordResponse(LocalTime.parse("00:00:00"), 0.0, 0.0, 0.0);
        for(Running running : runningList){
            if(running.getRunningDetail().getRunningMode().equals(Mode.GAME) &&
                    isDateWithinRange(running.getRunningDate(), gameStartDate, gameEndDate)){
                
                // 멤버의 지정된 기간의 게임 기록 합을 저장
                runningGameRecordResponse.addRecord(
                        running.getRunningDetail().getRunningTime().toLocalTime(),
                        running.getRunningDetail().getRunningPace(),
                        running.getRunningDetail().getRunningDistance(),
                        running.getRunningDetail().getRunningKcal());
            }
        }
        return runningGameRecordResponse;
    }

    public static boolean isDateWithinRange(LocalDate targetDate, LocalDate startDate, LocalDate endDate) {
        return targetDate.isEqual(startDate) ||
                targetDate.isEqual(endDate) ||
                (targetDate.isAfter(startDate) && targetDate.isBefore(endDate));
    }
}
