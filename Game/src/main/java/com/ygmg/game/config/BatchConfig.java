package com.ygmg.game.config;

import com.ygmg.game.db.model.RankingData;
import org.springframework.batch.core.*;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;

@Configuration
@EnableBatchProcessing
public class BatchConfig {

    @Autowired
    public JobBuilderFactory jobBuilderFactory;

    @Autowired
    public StepBuilderFactory stepBuilderFactory;

    // Define the job
    @Bean
    public Job migrateRankingJob() {
        return jobBuilderFactory.get("migrateRankingJob")
                .start(migrateRankingStep())
                .listener(new JobExecutionListener() {

                    @Autowired
                    StringRedisTemplate redisTemplate;

                    @Override
                    public void beforeJob(JobExecution jobExecution) {
                        // Nothing to do
                    }

                    @Override
                    public void afterJob(JobExecution jobExecution) {
                        // Delete all data in Redis after the job is done
                        redisTemplate.getConnectionFactory().getConnection().flushDb();
                    }
                })
                .build();
    }

    // Define the step
    @Bean
    public Step migrateRankingStep() {
        return stepBuilderFactory.get("migrateRankingStep")
                .<RankingData, RankingData> chunk(10)
                .reader(rankingDataReader())
                .processor(rankingDataProcessor())
                .writer(rankingDataWriter())
                .build();
    }

    // Define the reader, processor, and writer...
    
}

