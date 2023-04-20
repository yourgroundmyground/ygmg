package com.ygmg.running.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Running {

    @Id
    private Long id;

    private Long memberId;

    private LocalDate runningDate;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name="running_detail_id")
    private RunningDetail runningDetail;


}
