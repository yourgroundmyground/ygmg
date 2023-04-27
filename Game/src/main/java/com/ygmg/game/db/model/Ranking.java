package com.ygmg.game.db.model;

import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.index.Indexed;

import java.io.Serializable;

@Getter
@RedisHash("Ranking")
public class Ranking implements Serializable {
    @Id
    private String memberId;
    @Indexed
    private double areaSize;

}