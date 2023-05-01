package com.ygmg.game.api.service;

import com.ygmg.game.api.controller.GameResultController;
import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.db.model.Result;
import com.ygmg.game.db.repository.ResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameResultServiceImpl implements GameResultService {
    private final ResultRepository resultRepository;

    public GameResultServiceImpl(ResultRepository resultRepository){
        this.resultRepository = resultRepository;
    }
    @Override
    public Result getResultByResultId(int resultId) {
        Result result = resultRepository.findByResultId(resultId).get();
        return result;
    }

    @Override
    public Result createResult(ResultRegisterPostReq resultInfo) {
        Result result = Result.builder()
                .resultId(resultInfo.getResultId())
                .resultRanking(resultInfo.getResultRanking())
                .resultRanking(resultInfo.getResultRanking())
                .resultArea(resultInfo.getResultArea())
                .resultNickname(resultInfo.getResultNickname())
                .build();

        return resultRepository.save(result);
    }
}
