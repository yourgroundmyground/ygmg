package com.ygmg.game.api.service;

import com.ygmg.game.api.request.ResultRegisterPostReq;
import com.ygmg.game.api.response.ResultRes;
import com.ygmg.game.db.model.Result;

import java.util.List;

public interface GameResultService {

    Result createResult(ResultRegisterPostReq resultInfo);

    Result getResultByGameIdAndMemberId(Long gameId, Long memberId);

    List<ResultRes> getResultByGameId(Long gameId);
}
