package com.ygmg.game.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.request.RunningDataReq;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.api.service.GameResultService;
import com.ygmg.game.db.model.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/game/result")
public class GameResultController {
    // 게임 ID별 결과 조회
    private final GameResultService resultService;
    private final RabbitTemplate rabbitTemplate;
    private ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());


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

    @GetMapping("/running")
    public ResponseEntity<String> sendRunningData(@RequestBody RunningDataReq runningDataReq) throws JsonProcessingException {

        String message = objectMapper.writeValueAsString(runningDataReq);
        rabbitTemplate.convertAndSend("ygmg.exchange", "ygmg.game.#",message);

        return ResponseEntity.status(200).body("결과가 생성되었습니다.");
    }


//    @GetMapping("/{gameId}/{memberId}")
//    public ResponseEntity<ResultRes> getResultByMemberId(@PathVariable int gameId, @PathVariable int memberId) throws Exception {
//        Result result = resultService.getResultByGameIdAndMemberId(gameId, memberId);
//        return ResponseEntity.status(200).body(ResultRes.of(result));
//    }

    //Running 서비스 런닝 데이터 보내는 로직
    

}
