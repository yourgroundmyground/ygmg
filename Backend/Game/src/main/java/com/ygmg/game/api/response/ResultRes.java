package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResultRes {
    Long resultId;
    int resultRanking;
    double resultArea;
    Long memberId;
    Long gameId;

    public static ResultRes of(Result result){
        ResultRes res = new ResultRes();

        res.setResultId(result.getId());
        res.setResultRanking(result.getResultRanking());
        res.setResultArea(result.getResultArea());
        res.setMemberId(result.getMemberId());
        res.setGameId(result.getGame().getId());

        return res;
    }

}
