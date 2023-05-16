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
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
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

    private final AreaUtil areaUtil;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());


    @Override
    public void createAreaCoordinate(AreaCoordinateRegisterPostReq coordinateInfo) throws JsonProcessingException {

        List<Game> gameList = gameRepository.findAll();
        Game game = gameList.get(gameList.size() - 1);
        System.out.println();
        List<Area> areaList = areaRepository.findByGame_Id(game.getId());
        for(Area area : areaList){
            if(areaUtil.defeatCoordinates(area, coordinateInfo.getAreaCoordinateDtoList())){
                areaRepository.delete(area);
            }
        }

        coordinateInfo.setAreaSize(areaUtil.getAreaSize(coordinateInfo.getAreaCoordinateDtoList()));
        saveAreaCoordinateList(coordinateInfo);
        RunningDataSend(coordinateInfo);


    }

    public void saveAreaCoordinateList(AreaCoordinateRegisterPostReq coordinateInfo){

        List<Game> gameList = gameRepository.findAll();
        Game game = gameList.get(gameList.size() - 1);

        List<AreaCoordinate> list = new ArrayList<>();

        log.info(LocalDateTime.now() + "" );

        Area area = Area.builder()
                .areaDate(LocalDateTime.now())
                .areaSize(coordinateInfo.getAreaSize())
                .memberId(coordinateInfo.getMemberId())
                .game(game)
                .areaCoordinateList(list)
                .build();

        for(AreaCoordinateRegisterPostReq.AreaCoordinateDto areaCoordinateDto : coordinateInfo.getAreaCoordinateDtoList()){

            AreaCoordinate areaCoordinate = AreaCoordinate.builder()
                    .areaCoordinateLat(areaCoordinateDto.getAreaCoordinateLat())
                    .areaCoordinateLng(areaCoordinateDto.getAreaCoordinateLng())
                    .areaCoordinateTime(LocalDateTime.now())
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

    // 수정 Entity를 그대로 보내면 안됨!!!!!!!
    @Override
    public List<CoordinateRes> getCoordinateByAreaId(Long areaId) {
        List<AreaCoordinate>  coordinates = areaCoordinateRepository.findByArea_Id(areaId);
        List<CoordinateRes> coordinateResList = new ArrayList<>();
//        log.info(coordinates.get(0).getAreaCoordinateTime() + "" );

        for(AreaCoordinate coordinate : coordinates){
            coordinateResList.add(
                    CoordinateRes.builder()
                            .areaCoordinateId(coordinate.getId())
                            .areaCoordinateLat(coordinate.getAreaCoordinateLat())
                            .areaCoordinateLng(coordinate.getAreaCoordinateLng())
                            .areaCoordinateTime(coordinate.getAreaCoordinateTime())
                            .build()
            );
        }
        return coordinateResList;
    }

    // 수정 Entity를 그대로 보내면 안됨!!!!!!!
    @Override
    public AreaCoordinate getCoordinateByCoordinateId(Long areaCoordinateId) {
            AreaCoordinate coordinate = areaCoordinateRepository.findById(areaCoordinateId).get();
            return coordinate;
        }

}
