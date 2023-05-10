package com.ygmg.game.api.service;

import com.ygmg.game.api.controller.GameResultController;
import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import com.ygmg.game.db.repository.GameRepository;
import com.ygmg.game.db.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class GameResultServiceImpl implements GameResultService {
    private final ResultRepository resultRepository;

    private final GameRepository gameRepository;

    @Override
    public Result getResultByResultId(Long resultId) {
        Result result = resultRepository.findById(resultId).get();
        return result;
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
