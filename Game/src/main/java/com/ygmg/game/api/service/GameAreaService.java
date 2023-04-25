package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.db.model.Area;

import java.time.LocalDate;
import java.util.List;

public interface GameAreaService {
    List<AreaRes> getArea(int gameId);

    Area getAreaByAreaId(int areaId);

    List<AreaRes> getAreaByMemberId(int memberId);

    Area createArea(AreaRegisterPostReq areaInfo);

    void modifyArea(AreaModifyPutReq areaInfo);

    List<AreaRes> getAreaByMemberIdAndAreaDate(int memberId, LocalDate areaDate);
}
