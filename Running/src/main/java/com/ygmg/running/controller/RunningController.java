package com.ygmg.running.controller;


import com.ygmg.running.dto.RunningCoordinateResponse;
import com.ygmg.running.dto.RunningListResponse;
import com.ygmg.running.dto.RunningRequest;
import com.ygmg.running.dto.RunningResponse;
import com.ygmg.running.service.RunningService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RestController("/api/running")
public class RunningController {

    private final RunningService runningService;

    @PostMapping
    public ResponseEntity<?> saveRunningRecord(RunningRequest runningRequest){

        runningService.saveRunningRecord(runningRequest);

        return ResponseEntity.ok("성공적으로 저장되었습니다.");

    }
    @GetMapping("/{runningId}")
    public ResponseEntity<?> findRunningRecord(@PathVariable Long runningId){

        RunningResponse runningResponse = runningService.selectRunningDetail(runningId);

        return ResponseEntity.ok().body(runningResponse);
    }


    @GetMapping("/{runningDetailId}")
    public ResponseEntity<?> findRunningCoordinate(@PathVariable Long runningDetailId){

        RunningCoordinateResponse runningCoordinateResponse = runningService.selectRunningCoordinate(runningDetailId);

        return ResponseEntity.ok().body(runningCoordinateResponse);
    }

    @GetMapping("/{memberId}")
    public ResponseEntity<?> findAllRunning(@PathVariable Long memberId){

        RunningListResponse runningListResponse = runningService.selectRunningList(memberId);

        return ResponseEntity.ok().body(runningListResponse);
    }
}
