package com.ygmg.game.api.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ygmg.game.db.model.Game;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class GameRegisterPostReq {
//    int gameId;
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime gameStart;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime gameEnd;

    private String gamePlace;
}
