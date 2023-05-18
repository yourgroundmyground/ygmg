package com.ygmg.game.api.service;

import com.ygmg.game.api.request.AreaCoordinateRegisterPostReq;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import com.ygmg.game.db.repository.AreaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.locationtech.jts.geom.*;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@RequiredArgsConstructor
@Component
@Slf4j
public class AreaUtil {

    GeometryFactory factory = new GeometryFactory();
    private final AreaRepository areaRepository;

    private final GameRankingService rankingService;
    private final GameService gameService;

    public boolean defeatCoordinates(Area area, List<AreaCoordinateRegisterPostReq.AreaCoordinateDto> areaCoordinateDtoList){

        List<AreaCoordinate> defeatAreaCoordinateList = area.getAreaCoordinateList();
        Long memberId = area.getMemberId();
        LocalDateTime originLocalDateTime = area.getAreaDate();

        Coordinate [] defeatCoordinate = new Coordinate[defeatAreaCoordinateList.size()];
        Coordinate [] winCoordinates = new Coordinate[areaCoordinateDtoList.size()];

        for(int i = 0; i< defeatAreaCoordinateList.size(); i++){
            defeatCoordinate[i] = new Coordinate(defeatAreaCoordinateList.get(i).getAreaCoordinateLat(), defeatAreaCoordinateList.get(i).getAreaCoordinateLng());
        }
        for(int i = 0; i<areaCoordinateDtoList.size(); i++){
            winCoordinates[i] = new Coordinate(areaCoordinateDtoList.get(i).getAreaCoordinateLat(), areaCoordinateDtoList.get(i).getAreaCoordinateLng());
        }

        LinearRing defeatRing = factory.createLinearRing(defeatCoordinate);
        LinearRing winRing = factory.createLinearRing(winCoordinates);

        Polygon defeatPolygon = factory.createPolygon(defeatRing);
        Polygon winPolygon = factory.createPolygon(winRing);

        if(winPolygon.intersects(defeatPolygon)) {

            // difference는 겹친 부분의 면적
            Geometry difference = defeatPolygon.difference(winPolygon);
            long gameId = gameService.getGameId();
            rankingService.subAreaSize(String.valueOf(gameId), String.valueOf(memberId), defeatPolygon.getArea()-difference.getArea());
            if(difference instanceof MultiPolygon){
                System.out.println("멀티폴리곤 ");
                MultiPolygon multiPolygon = (MultiPolygon) difference;
                for (int i = 0; i < multiPolygon.getNumGeometries(); i++) {

                    //멀티 폴리곤 안에 있는 폴리곤 하나씩 추출
                    Polygon polygon = (Polygon) multiPolygon.getGeometryN(i);

                    List<AreaCoordinate> newAreaCoordinateList = new ArrayList<>();

                    Area newArea = Area.builder()
                            .areaCoordinateList(newAreaCoordinateList)
                            .areaDate(originLocalDateTime)
                            .areaSize(polygon.getArea())
                            .memberId(memberId)
                            .game(area.getGame())
                            .build();

                    for (Coordinate coordinate : polygon.getCoordinates()) {
                        newAreaCoordinateList.add(AreaCoordinate.builder()
                                .areaCoordinateLat(coordinate.x)
                                .areaCoordinateLng(coordinate.y)
                                .area(newArea)
                                .areaCoordinateTime(originLocalDateTime)
                                .build());
                    }

                    areaRepository.save(newArea);
                    System.out.println(i+"번째 폴리곤 넓이 : "+newArea.getAreaSize());
                }
            }
            else if(difference instanceof Polygon){
                Polygon polygon = (Polygon) difference;

                boolean donut = false;
                Coordinate[] coordinates = {};
                if(polygon.getArea() != 0){
                    coordinates = difference.getCoordinates();
                    double startX = coordinates[0].x;
                    double startY = coordinates[0].y;

                    for(int i = 1; i < coordinates.length - 1; i++) {
                        if (coordinates[i].x == startX && coordinates[i].y == startY) {
                            donut = true;
                            break;
                        }
                    }
                }

                List<AreaCoordinate> newAreaCoordinateList = new ArrayList<>();

                Area newArea = Area.builder()
                        .areaCoordinateList(newAreaCoordinateList)
                        .areaDate(originLocalDateTime)
                        .areaSize(polygon.getArea())
                        .memberId(memberId)
                        .game(area.getGame())
                        .build();

                for (Coordinate coordinate : difference.getCoordinates()) {
                    newAreaCoordinateList.add(AreaCoordinate.builder()
                            .areaCoordinateLat(coordinate.x)
                            .areaCoordinateLng(coordinate.y)
                            .area(newArea)
                            .areaCoordinateTime(LocalDateTime.now())
                            .build());
                }
                if(donut){
                    newArea.makeDonut(coordinates[0],newArea);
                }

                log.info("기존 폴리곤 사이즈는 : " + area.getAreaSize());
                log.info("패배한 폴리곤 사이즈는 : " + newArea.getAreaSize());

                areaRepository.save(newArea);

            }
            return true;
        }
        return false;
    }

    public double getAreaSize(List<AreaCoordinateRegisterPostReq.AreaCoordinateDto> areaCoordinateDtoList){
        Coordinate [] Coordinates = new Coordinate[areaCoordinateDtoList.size()];

        for(int i = 0; i<areaCoordinateDtoList.size(); i++){
            Coordinates[i] = new Coordinate(areaCoordinateDtoList.get(i).getAreaCoordinateLat(), areaCoordinateDtoList.get(i).getAreaCoordinateLng());
        }

        LinearRing linearRing = factory.createLinearRing(Coordinates);

        Polygon polygon = factory.createPolygon(linearRing);

        return polygon.getArea();
    }

}
