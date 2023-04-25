package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.db.model.Area;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/game/ranking")
public class GameRankingController {

    @GetMapping("/")
    public ResponseEntity<String> getRanking() throws Exception {

        return ResponseEntity.status(200).body("상위 3개 닉네임 , 면적");
    }

    @GetMapping("/{memberId}")
    public ResponseEntity<String> getRankingByMemberId(@PathVariable int memberId) throws Exception {

        return ResponseEntity.status(200).body("해당 멤버의 면적");
    }

}
