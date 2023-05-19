package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class GameRes {
    Long gameId;
    LocalDateTime gameStart;
    LocalDateTime gameEnd;
    String gamePlace;

    public static GameRes of(Game game){
        GameRes res = new GameRes();

        res.setGameId(game.getId());
        res.setGameStart(game.getGameStart());
        res.setGameEnd(game.getGameEnd());
        res.setGamePlace(game.getGamePlace());

        return res;
    }

}
