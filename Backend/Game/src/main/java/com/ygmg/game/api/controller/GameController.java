package com.ygmg.game.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ygmg.game.api.request.GameRegisterPostReq;
import com.ygmg.game.api.request.RunningDataReq;
import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.api.service.GameService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/game")
public class GameController {

    private final GameService gameService;

    /**
     * 게임 생성 Scheduled 어노테이션을 통해 자동 생성 되도록 수정함
     */

//    @PostMapping("/")
//    public ResponseEntity<String> createGame(@RequestBody GameRegisterPostReq gameInfo) throws Exception {
//        gameService.createGame(gameInfo);
//        return ResponseEntity.status(200).body("게임이 생성되었습니다.");
//    }

    @GetMapping("/")
    public ResponseEntity<List<GameRes>> getGame() throws Exception {
        List<GameRes> games = gameService.getGame();
        return ResponseEntity.status(200).body(games);
    }

    @PostMapping("/running")
    public ResponseEntity<String> sendRunningData(@RequestBody RunningDataReq runningDataReq) throws JsonProcessingException {

        log.debug("런닝 데이터 요청 아이디 : " + runningDataReq.getMemberId());

        String message = objectMapper.writeValueAsString(runningDataReq);

        rabbitTemplate.convertAndSend("ygmg.exchange", "ygmg.game.#",message);

        return ResponseEntity.status(200).body("저장되었습니다.");
    }

    @GetMapping("/gameId")
    public ResponseEntity<String> getGameId() throws Exception {
        String gameId = gameService.getGameId();
        return ResponseEntity.status(200).body(gameId);
    }
}
