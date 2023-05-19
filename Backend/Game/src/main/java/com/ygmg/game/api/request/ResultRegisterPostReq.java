package com.ygmg.game.api.request;

import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResultRegisterPostReq {
    int resultRanking;
    double resultArea;
    Long memberId;
    Long gameId;
}
