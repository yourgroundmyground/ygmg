package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaCoordinateRegisterPostReq;
import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.CoordinateRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import com.ygmg.game.db.repository.AreaCoordinateRepository;
import com.ygmg.game.db.repository.AreaRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class GameAreaCoordinateServiceImpl implements GameAreaCoordinateService {
    private final AreaCoordinateRepository areaCoordinateRepository;

    GameAreaCoordinateServiceImpl(AreaCoordinateRepository areaCoordinateRepository){
        this.areaCoordinateRepository = areaCoordinateRepository;
    }

    @Override
    public AreaCoordinate createAreaCoordinate(AreaCoordinateRegisterPostReq coordinateInfo) {
        AreaCoordinate cor = AreaCoordinate.builder()
                .areaCoordinateId(coordinateInfo.getAreaCoordinateId())
                .areaCoordinateLat(coordinateInfo.getAreaCoordinateLat())
                .areaCoordinateLng(coordinateInfo.getAreaCoordinateLng())
                .areaCoordinateTime(coordinateInfo.getAreaCoordinateTime())
                .area(coordinateInfo.getArea())
                .build();

        return areaCoordinateRepository.save(cor);
    }

    @Override
    public List<CoordinateRes> getCoordinateByAreaId(int areaId) {
        List<AreaCoordinate>  coordinates = areaCoordinateRepository.findByAreaAreaId(areaId);
        List<CoordinateRes> coordinateResList = new ArrayList<>();

        for(AreaCoordinate coordinate : coordinates){
            CoordinateRes res = CoordinateRes.of(coordinate);
            coordinateResList.add(res);
        }
        return coordinateResList;
    }

    @Override
    public AreaCoordinate getCoordinateByCoordinateId(int areaCoordinateId) {
            AreaCoordinate coordinate = areaCoordinateRepository.findByAreaCoordinateId(areaCoordinateId).get();

            return coordinate;
        }
}
