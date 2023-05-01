package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.GameRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.api.service.GameService;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/game")
public class GameController {

//    private final GameAreaService areaService;
    private final GameService gameService;

    public GameController(GameService gameService){
        this.gameService = gameService;
    }

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
}
