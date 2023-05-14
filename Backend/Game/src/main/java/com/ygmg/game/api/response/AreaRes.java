package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
public class AreaRes {
    Long areaId;
    Long memberId;
    LocalDateTime areaDate;
    Long gameId;

    List<CoordinateRes> coordinateList;

    public static AreaRes of(Area area){
        AreaRes res = new AreaRes();

        res.setAreaId(area.getId());
        res.setAreaDate(area.getAreaDate());
        res.setMemberId(area.getMemberId());
        res.setGameId(area.getGame().getId());

        return res;
    }


}
