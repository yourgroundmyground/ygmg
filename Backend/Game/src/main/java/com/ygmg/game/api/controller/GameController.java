package com.ygmg.game.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ygmg.game.api.request.GameRegisterPostReq;
import com.ygmg.game.api.request.RunningDataReq;
import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.api.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/game")
public class GameController {

//    private final GameAreaService areaService;
    private final GameService gameService;
    private final RabbitTemplate rabbitTemplate;
    private ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());


    @PostMapping("/")
    public ResponseEntity<String> createGame(@RequestBody GameRegisterPostReq gameInfo) throws Exception {
        gameService.createGame(gameInfo);
        return ResponseEntity.status(200).body("게임이 생성되었습니다.");
    }

    @GetMapping("/")
    public ResponseEntity<List<GameRes>> getGame() throws Exception {
        List<GameRes> games = gameService.getGame();
        return ResponseEntity.status(200).body(games);
    }
    @PostMapping("/save/running")
    public ResponseEntity<String> sendRunningData(@RequestBody RunningDataReq runningDataReq) throws JsonProcessingException {

        String message = objectMapper.writeValueAsString(runningDataReq);
        rabbitTemplate.convertAndSend("ygmg.exchange", "ygmg.game.#",message);

        return ResponseEntity.status(200).body("저장되었습니다.");
    }
}
