package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.repository.AreaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class GameAreaServiceImpl implements GameAreaService {
    private final AreaRepository areaRepository;

    GameAreaServiceImpl(AreaRepository areaRepository){
        this.areaRepository = areaRepository;
    }


    @Override
    public List<AreaRes> getArea(int gameId) {
        List<Area> areas = areaRepository.findByGameGameId(gameId);
        List<AreaRes> areaResList = new ArrayList<>();

        for(Area area : areas){
            AreaRes res = AreaRes.of(area);
            areaResList.add(res);
        }
        return areaResList;
    }

    @Override
    public Area getAreaByAreaId(int areaId) {
        Area area = areaRepository.findByAreaId(areaId).get();
        return area;
    }

    @Override
    public List<AreaRes> getAreaByMemberId(int memberId) {
        List<Area> areas = areaRepository.findByMemberId(memberId);
        List<AreaRes> areaResList = new ArrayList<>();

        for(Area area : areas){
            AreaRes res = AreaRes.of(area);
            areaResList.add(res);
        }
        return areaResList;
    }

    @Override
    public Area createArea(AreaRegisterPostReq areaInfo) {
        Area area = Area.builder()
                .areaDate(areaInfo.getAreaDate())
                .areaSize(areaInfo.getAreaSize())
                .memberId(areaInfo.getMemberId())
                .game(areaInfo.getGame())
                .build();

        return areaRepository.save(area);
    }

    @Override
    public void modifyArea(AreaModifyPutReq areaInfo) {
        int areaId = areaInfo.getAreaId();
        double modifySize = areaInfo.getAreaSize();
        areaRepository.updateAreaSize(areaId, modifySize);
    }



    @Override
    public List<AreaRes> getAreaByMemberIdAndAreaDate(int memberId, LocalDate areaDate) {
        LocalDateTime startDate = areaDate.atStartOfDay();
        LocalDateTime endDate = areaDate.plusDays(1).atStartOfDay();

        List<Area> areas = areaRepository.findByMemberIdAndAreaDate(memberId, startDate, endDate);
        List<AreaRes> areaResList = new ArrayList<>();

        for(Area area : areas){
            AreaRes res = AreaRes.of(area);
            areaResList.add(res);
        }
        return areaResList;
    }
}
