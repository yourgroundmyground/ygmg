package com.ygmg.game.api.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ygmg.game.api.request.AreaCoordinateRegisterPostReq;
import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.CoordinateRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;

import java.util.List;

public interface GameAreaCoordinateService {
//    List<AreaRes> getArea(int gameId);
//
//    Area getAreaByAreaId(int areaId);
//
//    List<AreaRes> getAreaByMemberId(int memberId);

    void createAreaCoordinate(AreaCoordinateRegisterPostReq coordinateInfo) throws JsonProcessingException;

    List<CoordinateRes> getCoordinateByAreaId(Long areaId);

    AreaCoordinate getCoordinateByCoordinateId(Long areaCoordinateId);
}
