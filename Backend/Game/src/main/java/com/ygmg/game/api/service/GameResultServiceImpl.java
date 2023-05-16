package com.ygmg.game.api.service;

import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.response.AreaRes;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.db.model.Area;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import com.ygmg.game.db.repository.GameRepository;
import com.ygmg.game.db.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class GameResultServiceImpl implements GameResultService {
    private final ResultRepository resultRepository;

    private final GameRepository gameRepository;

    @Override
    public List<ResultRes> getResultByGameId(Long gameId) {
        List<Result> results = resultRepository.findByGame_Id(gameId);
        List<ResultRes> resultResList = new ArrayList<>();

        for(Result result : results){
            ResultRes res = ResultRes.of(result);
            resultResList.add(res);
        }
        return resultResList;
    }

    @Override
    public Result createResult(ResultRegisterPostReq resultInfo) {

        Game game = gameRepository.findById(resultInfo.getGameId()).get();
        Result result = Result.builder()
                .resultRanking(resultInfo.getResultRanking())
                .resultRanking(resultInfo.getResultRanking())
                .resultArea(resultInfo.getResultArea())
                .memberId(resultInfo.getMemberId())
                .game(game)
                .build();

        return resultRepository.save(result);
    }

    @Override
    public Result getResultByGameIdAndMemberId(Long gameId, Long memberId) {
        return resultRepository.findByGame_IdAndMemberId(gameId, memberId)
                .orElseThrow(() -> new NoSuchElementException("No Result found with gameId: " + gameId + " and memberId: " + memberId));
    }
}
