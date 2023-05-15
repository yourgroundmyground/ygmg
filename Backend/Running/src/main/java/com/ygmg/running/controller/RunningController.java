package com.ygmg.running.controller;


import com.ygmg.running.dto.*;
import com.ygmg.running.entity.Mode;
import com.ygmg.running.service.RunningService;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/running")
public class RunningController {

    private final RunningService runningService;

    @PostMapping
    @ApiOperation(value = "런닝 기록 저장", notes = "런닝 기록 저장합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "저장 성공")
    })
    public ResponseEntity<?> saveRunningRecord(@RequestBody  RunningRequest runningRequest){

        runningService.saveRunningRecord(runningRequest, Mode.RUNNING);

        return ResponseEntity.ok("성공적으로 저장되었습니다.");

    }
    @GetMapping("/detail/{runningId}")
    @ApiOperation(value = "런닝 상세 기록 조회", notes = "런닝 상세 기록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "조회 성공", response = RunningResponse.class)
    })
    public ResponseEntity<?> findRunningRecord(@PathVariable Long runningId){

        RunningResponse runningResponse = runningService.selectRunningDetail(runningId);

        return ResponseEntity.ok().body(runningResponse);
    }


    @GetMapping("/coordinate/{runningDetailId}")
    @ApiOperation(value = "런닝 좌표 리스트 조회", notes = "런닝 좌표 리스트를 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "조회 성공", response = RunningCoordinateResponse.class)
    })
    public ResponseEntity<?> findRunningCoordinate(@PathVariable String runningDetailId){

        RunningCoordinateResponse runningCoordinateResponse = runningService.selectRunningCoordinate(Long.parseLong(runningDetailId));

        return ResponseEntity.ok().body(runningCoordinateResponse);
    }

    @GetMapping("/{memberId}")
    @ApiOperation(value = "회원 단위 런닝 기록 전체 조회", notes = "회원이 가지고 있는 런닝 내역을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "조회 성공", response = RunningListResponse.class)
    })
    public ResponseEntity<?> findAllRunning(@PathVariable Long memberId){

        RunningListResponse runningListResponse = runningService.selectRunningList(memberId);

        return new ResponseEntity<RunningListResponse>(runningListResponse, HttpStatus.OK);
    }

    // yyyy-MM-dd
    @GetMapping("/detail/{memberId}/{gameStartDate}/{gameEndDate}")
    @ApiOperation(value = "특정 기간 게임 런닝기록 조회", notes = "특정 기간 게임에서 달린 기록을 조회합니다.")
    @ApiResponses({
//            @ApiResponse(code = 200, message = "조회 성공", response = RunningListResponse.class)
    })
    public ResponseEntity<?> findGameRunningRecord(
            @PathVariable Long memberId,
            @PathVariable @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate gameStartDate,
            @PathVariable @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate gameEndDate
    ){
        RunningGameRecordResponse runningGameRecordResponse = runningService.selectGameRunningDetail(memberId, gameStartDate, gameEndDate);

        return new ResponseEntity<RunningGameRecordResponse>(runningGameRecordResponse, HttpStatus.OK);
    }
}
