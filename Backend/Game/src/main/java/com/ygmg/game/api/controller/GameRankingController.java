package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.RankingUpdateReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.RankingRes;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.api.service.GameRankingService;
import com.ygmg.game.db.model.Area;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/game/ranking")
public class GameRankingController {

    private final GameRankingService rankingService;
    public GameRankingController(GameRankingService rankingService){
        this.rankingService = rankingService;
    }
    @GetMapping("/top")
    public ResponseEntity<List<RankingRes>> getRanking() throws Exception {
        Set<ZSetOperations.TypedTuple<String>> topRankings = rankingService.getTopScores();

        List<RankingRes> rankingInfoList = topRankings.stream()
                .map(tuple -> new RankingRes(tuple.getValue(), tuple.getScore()))
                .collect(Collectors.toList());
        return ResponseEntity.status(200).body(rankingInfoList);
    }

    @GetMapping("/{memberId}")
    public ResponseEntity<Integer> getRankingByMemberId(@PathVariable int memberId) throws Exception {
        String id = Integer.toString(memberId);
        System.out.println(id);
        int rank = rankingService.getRank(id);
        return ResponseEntity.status(200).body(rank);
    }

    @PostMapping("/add")
    public ResponseEntity<String> addRanking(@RequestBody RankingUpdateReq rankingUpdateReq) {
        rankingService.updateAreaSize(rankingUpdateReq.getMemberId(), rankingUpdateReq.getAreaSize());
        return ResponseEntity.status(200).body("Member area size has been added successfully.");
    }


}
