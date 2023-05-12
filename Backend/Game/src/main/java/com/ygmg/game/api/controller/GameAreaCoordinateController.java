package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaCoordinateRegisterPostReq;
import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.CoordinateRes;
import com.ygmg.game.api.service.GameAreaCoordinateService;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.AreaCoordinate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/game/coordinate")
public class GameAreaCoordinateController {
    private final GameAreaCoordinateService coordinateService;
    public GameAreaCoordinateController(GameAreaCoordinateService coordinateService){
        this.coordinateService = coordinateService;
    }
    @PostMapping("/")
    public ResponseEntity<String> createCoordinate(@RequestBody AreaCoordinateRegisterPostReq areaCoordinateRegisterPostReq) throws Exception {

        coordinateService.createAreaCoordinate(areaCoordinateRegisterPostReq);

        return ResponseEntity.status(200).body("면적이 생성되었습니다.");
    }

    @GetMapping("/{areaCoordinateId}")
    public ResponseEntity<AreaCoordinate> getCoordinate(@PathVariable Long areaCoordinateId) throws Exception {
        AreaCoordinate coordinate = coordinateService.getCoordinateByCoordinateId(areaCoordinateId);
        return ResponseEntity.status(200).body(coordinate);
    }

    @GetMapping("/area/{areaId}")
    public ResponseEntity<List<CoordinateRes>> getAreaCoordinate(@PathVariable Long areaId) throws Exception {
        List<CoordinateRes> coordinates = coordinateService.getCoordinateByAreaId(areaId);
        return ResponseEntity.ok(coordinates);
    }

}
