package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AreaRes {
    int areaId;
    int memberId;
    LocalDateTime areaDate;
    Game game;

    public static AreaRes of(Area area){
        AreaRes res = new AreaRes();

        res.setAreaId(area.getAreaId());
        res.setAreaDate(area.getAreaDate());
        res.setMemberId(area.getMemberId());
        res.setGame(area.getGame());

        return res;
    }

}
