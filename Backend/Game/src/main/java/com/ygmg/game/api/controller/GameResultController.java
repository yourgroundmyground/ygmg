package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.api.service.GameRankingService;
import com.ygmg.game.api.service.GameResultService;
import com.ygmg.game.api.service.GameService;
import com.ygmg.game.db.model.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/game/result")
public class GameResultController {
    // 게임 ID별 결과 조회
    private final GameResultService resultService;
    private final GameService gameService;
    public GameResultController(GameResultService resultService, GameService gameService){
        this.resultService = resultService;
        this.gameService = gameService;
    }

    @GetMapping("/{gameId}")
    public ResponseEntity<List<ResultRes>> getResult(@PathVariable Long gameId) throws Exception {
        List<ResultRes> list =  resultService.getResultByGameId(gameId);
        return ResponseEntity.status(200).body(list);
    }

    // 게임 종료 후 결과 생성
    @PostMapping("")
    public ResponseEntity<String> createResult(@RequestBody ResultRegisterPostReq resultInfo) throws Exception {
        resultService.createResult(resultInfo);
        return ResponseEntity.status(200).body("결과가 생성되었습니다.");
    }

    @GetMapping("/count")
    public ResponseEntity<Integer> getCount() throws Exception {
        long gameId = gameService.getGameId();
        String gid = Long.toString(gameId);
        int cnt = resultService.getCount(gid);
        return ResponseEntity.status(200).body(cnt);
    }

    @GetMapping("/{gameId}/{memberId}")
    public ResponseEntity<ResultRes> getResultByMemberId(@PathVariable Long gameId, @PathVariable Long memberId) throws Exception {
        Result result = resultService.getResultByGameIdAndMemberId(gameId, memberId);
        return ResponseEntity.status(200).body(ResultRes.of(result));
    }

    //Running 서비스 런닝 데이터 보내는 로직
    

}
