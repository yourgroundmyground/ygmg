package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Ranking;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class RankingRes {
    String memberId;
    double areaSize;

    public RankingRes(String memberId, Double areaSize) {
        this.memberId = memberId;
        this.areaSize = areaSize;
    }

}
