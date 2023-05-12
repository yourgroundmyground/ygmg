package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.GameRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.repository.AreaRepository;
import com.ygmg.game.db.repository.GameRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class GameServiceImpl implements GameService {
    private final GameRepository gameRepository;

    GameServiceImpl(GameRepository gameRepository){
        this.gameRepository = gameRepository;
    }


//    @Override
//    public Game createGame(GameRegisterPostReq gameInfo) {
//
//        Game game = Game.builder()
//                .gameStart(gameInfo.getGameStart())
//                .gameEnd(gameInfo.getGameEnd())
//                .gamePlace(gameInfo.getGamePlace())
//                .build();
//
//        return gameRepository.save(game);
//    }


    @Override
    @Transactional
    @Scheduled(cron = "0 0 0 ? * TUE")
    public Game createGame() {

        Game game = Game.builder()
                .gameStart(LocalDateTime.now())
                .gameEnd(LocalDateTime.now().plusDays(6))
                .gamePlace("광주")
                .build();

        gameRepository.save(game);

        return null;
    }

    @Override
    public List<GameRes> getGame() {
        List<Game> games = gameRepository.findAll();
        List<GameRes> gameResList = new ArrayList<>();

        for(Game game : games){
            GameRes res = GameRes.of(game);
            gameResList.add(res);
        }
        return gameResList;
    }

    @Override
    public String getGameId() {
        String gameId = gameRepository.findGameId();
        return gameId;
    }

}
