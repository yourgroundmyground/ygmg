package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.api.service.GameResultService;
import com.ygmg.game.db.model.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/game/result")
public class GameResultController {
    // 게임 ID별 결과 조회
    private final GameResultService resultService;

    public GameResultController(GameResultService resultService){
        this.resultService = resultService;
    }

    @GetMapping("/{resultId}")
    public ResponseEntity<ResultRes> getResult(@PathVariable int resultId) throws Exception {
        Result result = resultService.getResultByResultId(resultId);
        return ResponseEntity.status(200).body(ResultRes.of(result));
    }

    // 게임 종료 후 결과 생성
    @PostMapping("/")
    public ResponseEntity<String> createResult(@RequestBody ResultRegisterPostReq resultInfo) throws Exception {
        resultService.createResult(resultInfo);
        return ResponseEntity.status(200).body("결과가 생성되었습니다.");
    }
}
