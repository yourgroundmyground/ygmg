package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.GameRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.GameRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;

import java.util.List;

public interface GameService {
//    Game createGame(GameRegisterPostReq gameInfo);

    Game createGame();

    List<GameRes> getGame();

    String getGameId();
}
