package com.ygmg.game.config;

import com.ygmg.game.db.model.RankingData;
import org.springframework.batch.core.*;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.database.builder.JdbcBatchItemWriterBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.*;

import java.util.Map.Entry;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

@Configuration
@EnableBatchProcessing
public class BatchConfig {
    private static final String SCORES_KEY = "scores";
    @Autowired
    public JobBuilderFactory jobBuilderFactory;

    @Autowired
    public StepBuilderFactory stepBuilderFactory;

    @Resource(name="redisBatchTemplate")
    private RedisTemplate<String, RankingData> redisTemplate;

    @Autowired
    private DataSource dataSource;

    @Bean
    public ItemReader<RankingData> rankingDataReader() {
        return new RedisItemReader();
    }

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
                        if (redisTemplate == null) {
                            System.out.println("redisTemplate is null");
                        } else if (redisTemplate.getConnectionFactory() == null) {
                            System.out.println("getConnectionFactory is null");
                        } else if (redisTemplate.getConnectionFactory().getConnection() == null) {
                            System.out.println("getConnection is null");
                        } else {
                            redisTemplate.getConnectionFactory().getConnection().flushDb();
                        }
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


    // Define Reader, Processor, Writer...
    class RedisItemReader implements ItemReader<RankingData> {

        private Cursor<ZSetOperations.TypedTuple<RankingData>> cursor;

        @PostConstruct
        private void openCursor() {
            this.cursor = redisTemplate.opsForZSet().scan(SCORES_KEY, ScanOptions.NONE);
        }

        @Override
        public RankingData read() {
            if(cursor.hasNext()){
                Entry<String, Double> entry = (Entry<String, Double>) cursor.next();
                return new RankingData(entry.getKey(), entry.getValue());
            } else {
                return null;
            }
        }
    }

    @Bean
    public ItemProcessor<RankingData, RankingData> rankingDataProcessor() {
        return item -> item;
    }

    @Bean
    public ItemWriter<RankingData> rankingDataWriter() {
        return new JdbcBatchItemWriterBuilder<RankingData>()
                .beanMapped()
                .dataSource(dataSource)
                .sql("INSERT INTO rankings (memberId, score) VALUES (:memberId, :score)")
                .build();
    }


}

