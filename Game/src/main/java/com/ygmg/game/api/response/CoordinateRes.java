package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class CoordinateRes {
    int areaCoordinateId;
    double areaCoordinateLat;
    double areaCoordinateLng;
    LocalDateTime areaCoordinateTime;
    Area area;

    public static CoordinateRes of(AreaCoordinate areaCoordinate){
        CoordinateRes res = new CoordinateRes();

        res.setAreaCoordinateId(areaCoordinate.getAreaCoordinateId());
        res.setAreaCoordinateLat(areaCoordinate.getAreaCoordinateLat());
        res.setAreaCoordinateLng(areaCoordinate.getAreaCoordinateLng());
        res.setAreaCoordinateTime(areaCoordinate.getAreaCoordinateTime());
        res.setArea(areaCoordinate.getArea());

        return res;
    }

}
