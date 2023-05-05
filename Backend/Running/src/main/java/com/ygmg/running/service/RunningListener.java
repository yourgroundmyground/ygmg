package com.ygmg.running.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ygmg.running.dto.RunningRequest;
import com.ygmg.running.entity.Mode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@RequiredArgsConstructor
public class RunningListener {

    private final RunningService runningService;
    ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());
    @RabbitListener(queues = "ygmg.eventqueue")
    public void receiveMessage(@Payload String message) throws JsonProcessingException {
        RunningRequest runningRequest = objectMapper.readValue(message, RunningRequest.class);
        log.info("message.memberID : " + runningRequest.getMemberId());
        log.info("message.runningStartTime : " + runningRequest.getCoordinateList().get(0).getCoordinateTime());
        runningService.saveRunningRecord(runningRequest, Mode.GAME);
    }

}
