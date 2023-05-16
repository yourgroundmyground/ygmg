package com.ygmg.game.api.controller;

import com.ygmg.game.api.request.AreaModifyPutReq;
import com.ygmg.game.api.request.AreaRegisterPostReq;
import com.ygmg.game.api.request.RankingUpdateReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.RankAndAreaSizeRes;
import com.ygmg.game.api.response.RankingRes;
import com.ygmg.game.api.service.GameAreaService;
import com.ygmg.game.api.service.GameRankingService;
import com.ygmg.game.api.service.GameService;
import com.ygmg.game.api.service.GameServiceImpl;
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
    private final GameService gameService;
    public GameRankingController(GameRankingService rankingService, GameService gameService){
        this.rankingService = rankingService;
        this.gameService = gameService;
    }
    @GetMapping("/top")
    public ResponseEntity<List<RankingRes>> getRanking() throws Exception {
        long gameId = gameService.getGameId();
        String gid = Long.toString(gameId);
        Set<ZSetOperations.TypedTuple<String>> topRankings = rankingService.getTopScores(gid);

        List<RankingRes> rankingInfoList = topRankings.stream()
                .map(tuple -> new RankingRes(tuple.getValue(), tuple.getScore()))
                .collect(Collectors.toList());
        return ResponseEntity.status(200).body(rankingInfoList);
    }

    @GetMapping("/{memberId}")
    public ResponseEntity<RankAndAreaSizeRes> getRankingByMemberId(@PathVariable int memberId) throws Exception {
        RankAndAreaSizeRes res = new RankAndAreaSizeRes(rank, );
        long gameId = gameService.getGameId();
        String gid = Long.toString(gameId);
        String mid = Integer.toString(memberId);
        int rank = rankingService.getRank(gid, mid);
        res.setRank(rank);
        return ResponseEntity.status(200).body(res);
    }

    @GetMapping("/count")
    public ResponseEntity<Integer> getCount() throws Exception {
        long gameId = gameService.getGameId();
        String gid = Long.toString(gameId);
        int cnt = rankingService.getCount(gid);
        return ResponseEntity.status(200).body(cnt);
    }

    @PostMapping("/")
    public ResponseEntity<String> addRanking(@RequestBody RankingUpdateReq rankingUpdateReq) {
        rankingUpdateReq.setGameId(String.valueOf(gameService.getGameId()));
        rankingService.addAreaSize(rankingUpdateReq.getGameId(), rankingUpdateReq.getMemberId(), rankingUpdateReq.getAreaSize());
        return ResponseEntity.status(200).body("Member area size has been added successfully.");
    }

    @PostMapping("/sub")
    public ResponseEntity<String> subRanking(@RequestBody RankingUpdateReq rankingUpdateReq) {
        rankingUpdateReq.setGameId(String.valueOf(gameService.getGameId()));
        rankingService.subAreaSize(rankingUpdateReq.getGameId(), rankingUpdateReq.getMemberId(), rankingUpdateReq.getAreaSize());
        return ResponseEntity.status(200).body("Member area size has been subed successfully.");
    }

    @PutMapping("/")
    public ResponseEntity<String> modifyRanking(@RequestBody RankingUpdateReq rankingUpdateReq) {
        rankingUpdateReq.setGameId(String.valueOf(gameService.getGameId()));
        rankingService.modifyAreaSize(rankingUpdateReq.getGameId(), rankingUpdateReq.getMemberId(), rankingUpdateReq.getAreaSize());
        return ResponseEntity.status(200).body("Member area size has been added successfully.");
    }

}
