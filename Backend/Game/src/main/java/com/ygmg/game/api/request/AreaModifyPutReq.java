package com.ygmg.game.api.request;

import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AreaModifyPutReq {
    Long areaId;
    double areaSize;
}
