package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.repository.AreaRepository;
import com.ygmg.game.db.repository.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class GameAreaServiceImpl implements GameAreaService {
    private final AreaRepository areaRepository;

    private final GameRepository gameRepository;



    @Override
    public List<AreaRes> getArea(Long gameId) {
        List<Area> areas = areaRepository.findByGame_Id(gameId);
        List<AreaRes> areaResList = new ArrayList<>();

        for(Area area : areas){
            AreaRes res = AreaRes.of(area);
            areaResList.add(res);
        }
        return areaResList;
    }

    @Override
    public Area getAreaByAreaId(Long areaId) {
        Area area = areaRepository.findById(areaId).get();
        return area;
    }

    @Override
    public List<AreaRes> getAreaByMemberId(Long memberId) {
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

        Game game = gameRepository.findById(areaInfo.getGameId()).get();

        Area area = Area.builder()
                .areaDate(areaInfo.getAreaDate())
                .areaSize(areaInfo.getAreaSize())
                .memberId(areaInfo.getMemberId())
                .game(game)
                .build();

        return areaRepository.save(area);
    }

    @Override
    public void modifyArea(AreaModifyPutReq areaInfo) {
        Long areaId = areaInfo.getAreaId();
        double modifySize = areaInfo.getAreaSize();
        Area area = areaRepository.findById(areaId).get();
        area.updateAreaSize(modifySize);
        areaRepository.save(area);
    }



    @Override
    public List<AreaRes> getAreaByMemberIdAndAreaDate(Long memberId, LocalDate areaDate) {
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
