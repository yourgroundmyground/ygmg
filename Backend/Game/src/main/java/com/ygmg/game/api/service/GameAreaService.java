package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.db.model.Area;

import java.time.LocalDate;
import java.util.List;

public interface GameAreaService {
    List<AreaRes> getArea(Long gameId);

    Area getAreaByAreaId(Long areaId);

    List<AreaRes> getAreaByMemberId(Long memberId);

    Area createArea(AreaRegisterPostReq areaInfo);

    void modifyArea(AreaModifyPutReq areaInfo);

//    List<AreaRes> getAreaByMemberIdAndAreaDate(Long memberId, LocalDate areaDate);

    List<AreaRes> getAreaByMemberIdAndGameId(Long memberId, Long gameId);
}
