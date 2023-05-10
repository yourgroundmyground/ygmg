package com.ygmg.game.api.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ygmg.game.api.request.AreaCoordinateRegisterPostReq;
import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.RunningDataReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.CoordinateRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.repository.AreaCoordinateRepository;
import com.ygmg.game.db.repository.AreaRepository;
import com.ygmg.game.db.repository.GameRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class GameAreaCoordinateServiceImpl implements GameAreaCoordinateService {
    private final AreaCoordinateRepository areaCoordinateRepository;
    private final AreaRepository areaRepository;

    private final GameRepository gameRepository;

    private final RabbitTemplate rabbitTemplate;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());


    @Override
    public void createAreaCoordinate(AreaCoordinateRegisterPostReq coordinateInfo) throws JsonProcessingException {


        saveAreaCoordinateList(coordinateInfo);

        RunningDataSend(coordinateInfo);

    }

    public void saveAreaCoordinateList(AreaCoordinateRegisterPostReq coordinateInfo){

        Game game = gameRepository.findById(coordinateInfo.getGameId()).get();

        List<AreaCoordinate> list = new ArrayList<>();

        log.info(coordinateInfo.getAreaDate() + "" );

        Area area = Area.builder()
                .areaDate(coordinateInfo.getAreaDate())
                .areaSize(coordinateInfo.getAreaSize())
                .memberId(coordinateInfo.getMemberId())
                .game(game)
                .areaCoordinateList(list)
                .build();

        for(AreaCoordinateRegisterPostReq.AreaCoordinateDto areaCoordinateDto : coordinateInfo.getAreaCoordinateDtoList()){

            AreaCoordinate areaCoordinate = AreaCoordinate.builder()
                    .areaCoordinateLat(areaCoordinateDto.getAreaCoordinateLat())
                    .areaCoordinateLng(areaCoordinateDto.getAreaCoordinateLng())
                    .areaCoordinateTime(areaCoordinateDto.getAreaCoordinateTime())
                    .area(area)
                    .build();

            list.add(areaCoordinate);
        }
        areaRepository.save(area);
    }

    public void RunningDataSend(AreaCoordinateRegisterPostReq coordinateInfo) throws JsonProcessingException {


        log.debug("런닝 데이터 요청 아이디 : " + coordinateInfo.getMemberId());


        List<RunningDataReq.Coordinate> coordinateList = new ArrayList<>();

        for(AreaCoordinateRegisterPostReq.AreaCoordinateDto areaCoordinateDto: coordinateInfo.getAreaCoordinateDtoList()){

            coordinateList.add(
                    RunningDataReq.Coordinate.builder()
                            .lat(areaCoordinateDto.getAreaCoordinateLat())
                            .lng(areaCoordinateDto.getAreaCoordinateLng())
                            .coordinateTime(areaCoordinateDto.getAreaCoordinateTime().toLocalTime())
                            .build());

        }

        RunningDataReq runningDataReq = RunningDataReq.builder()
                .coordinateList(coordinateList)
                .runningDistance(coordinateInfo.getRunningDistance())
                .runningStart(coordinateInfo.getRunningStart())
                .runningEnd(coordinateInfo.getRunningEnd())
                .runningKcal(coordinateInfo.getRunningKcal())
                .runningPace(coordinateInfo.getRunningPace())
                .runningTime(coordinateInfo.getRunningTime())
                .memberId(coordinateInfo.getMemberId())
                .build();


        String message = objectMapper.writeValueAsString(runningDataReq);

        rabbitTemplate.convertAndSend("ygmg.exchange", "ygmg.game.#",message);

    }
    @Override
    public List<CoordinateRes> getCoordinateByAreaId(Long areaId) {
        List<AreaCoordinate>  coordinates = areaCoordinateRepository.findByArea_Id(areaId);
        List<CoordinateRes> coordinateResList = new ArrayList<>();

        for(AreaCoordinate coordinate : coordinates){
            CoordinateRes res = CoordinateRes.of(coordinate);
            coordinateResList.add(res);
        }
        return coordinateResList;
    }

    @Override
    public AreaCoordinate getCoordinateByCoordinateId(Long areaCoordinateId) {
            AreaCoordinate coordinate = areaCoordinateRepository.findById(areaCoordinateId).get();
            return coordinate;
        }

}
