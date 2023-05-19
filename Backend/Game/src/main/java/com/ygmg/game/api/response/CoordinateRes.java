package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import com.ygmg.game.db.model.Game;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
public class CoordinateRes {
    Long areaCoordinateId;
    double areaCoordinateLat;
    double areaCoordinateLng;
    LocalDateTime areaCoordinateTime;

}
