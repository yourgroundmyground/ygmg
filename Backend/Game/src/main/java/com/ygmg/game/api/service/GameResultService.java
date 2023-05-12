package com.ygmg.game.api.service;

import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.db.model.Result;

public interface GameResultService {
    Result getResultByResultId(Long resultId);

    Result createResult(ResultRegisterPostReq resultInfo);

    Result getResultByGameIdAndMemberId(Long gameId, Long memberId);
}
