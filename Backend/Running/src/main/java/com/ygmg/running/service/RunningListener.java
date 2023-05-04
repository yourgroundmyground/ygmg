package com.ygmg.running.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ygmg.running.dto.RunningRequest;
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
    ObjectMapper objectMapper = new ObjectMapper();
    @RabbitListener(queues = "ygmg.eventqueue")
    public void receiveMessage(@Payload String message) throws JsonProcessingException {
        RunningRequest runningRequest = objectMapper.readValue(message, RunningRequest.class);
        log.info("message.memberID : " + runningRequest.getMemberId());
        runningService.saveRunningRecord(runningRequest);
    }

}
