package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.db.model.Area;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/game/area")
public class GameAreaController {
    private final GameAreaService areaService;
    public GameAreaController(GameAreaService areaService){
        this.areaService = areaService;
    }
    @PostMapping("/")
    public ResponseEntity<String> createArea(@RequestBody AreaRegisterPostReq areaInfo) throws Exception {
        areaService.createArea(areaInfo);
        return ResponseEntity.status(200).body("면적이 생성되었습니다.");
    }
//  해당 면적 ID에 해당하는 면적의 넓이 수정
    @PutMapping("/")
    public ResponseEntity<String> modifyArea(@RequestBody AreaModifyPutReq areaInfo) throws Exception {
        areaService.modifyArea(areaInfo);

        return ResponseEntity.status(200).body("면적이 변경되었습니다.");
    }
    @GetMapping("/{areaId}")
    public ResponseEntity<AreaRes> getArea(@PathVariable int areaId) throws Exception {
        Area area = areaService.getAreaByAreaId(areaId);
        return ResponseEntity.status(200).body(AreaRes.of(area));
    }

    @GetMapping("game/{gameId}")
    public ResponseEntity<List<AreaRes>> getGameArea(@PathVariable int gameId) throws Exception {
        List<AreaRes> areas = areaService.getArea(gameId);
        return ResponseEntity.status(200).body(areas);
    }


    @GetMapping("member/{memberId}")
    public ResponseEntity<List<AreaRes>> getMemberAreaAll(@PathVariable int memberId) throws Exception {
        List<AreaRes> areas = areaService.getAreaByMemberId(memberId);
        return ResponseEntity.status(200).body(areas);
    }
    @GetMapping("member/{memberId}/{areaDate}")
    public ResponseEntity<List<AreaRes>> getMemberArea(@PathVariable int memberId, @PathVariable @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate areaDate) throws Exception {
        List<AreaRes> areas = areaService.getAreaByMemberIdAndAreaDate(memberId, areaDate);
        return ResponseEntity.status(200).body(areas);
    }
}
