package com.ygmg.game.api.request;

import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AreaRegisterPostReq {
    int areaId;
    int memberId;
    LocalDateTime areaDate;

    double areaSize;
    Game game;
}
