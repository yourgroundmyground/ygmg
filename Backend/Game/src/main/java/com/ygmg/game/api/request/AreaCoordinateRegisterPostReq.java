package com.ygmg.game.api.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AreaCoordinateRegisterPostReq {
    double areaCoordinateLat;
    double areaCoordinateLng;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    LocalDateTime areaCoordinateTime;
    Area area;
}
