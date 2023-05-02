package com.ygmg.game.api.response;


import com.ygmg.game.db.model.Game;
import com.ygmg.game.db.model.Result;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResultRes {
    int resultId;
    int resultRanking;
    double resultArea;
    int memberId;
    Game game;

    public static ResultRes of(Result result){
        ResultRes res = new ResultRes();

        res.setResultId(result.getResultId());
        res.setResultRanking(result.getResultRanking());
        res.setResultArea(result.getResultArea());
        res.setMemberId(result.getMemberId());
        res.setGame(result.getGame());

        return res;
    }

}
