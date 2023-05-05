package com.ygmg.game.config;

import com.ygmg.game.db.model.RankingData;
import org.springframework.batch.core.*;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.database.BeanPropertyItemSqlParameterSourceProvider;
import org.springframework.batch.item.database.builder.JdbcBatchItemWriterBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.*;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;

import java.util.Map.Entry;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.sql.DataSource;

@Configuration
@EnableBatchProcessing
public class BatchConfig {
    private static final String SCORES_KEY = "scores";
    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;
    private final DataSource dataSource;
    private final RedisTemplate<String, RankingData> redisTemplate;

    public BatchConfig(JobBuilderFactory jobBuilderFactory, StepBuilderFactory stepBuilderFactory, DataSource dataSource, @Qualifier("redisBatchTemplate") RedisTemplate<String, RankingData> redisTemplate){
        this.jobBuilderFactory = jobBuilderFactory;
        this.stepBuilderFactory = stepBuilderFactory;
        this.dataSource = dataSource;
        this.redisTemplate = redisTemplate;
    }


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

    // ! 아직 구현 안됨
    // 결과 테이블로 옮기기 : gameId, memberId, resultArea, resultRanking,
    //
    @Bean
    public ItemWriter<RankingData> rankingDataWriter() {

        return new JdbcBatchItemWriterBuilder<RankingData>()
                .beanMapped()
                .dataSource(dataSource)
                .sql("INSERT INTO result (gameId, memberId, resultArea, resultRanking) VALUES (:gameId, :memberId, :resultArea, :resultRanking)")
                .itemSqlParameterSourceProvider(new BeanPropertyItemSqlParameterSourceProvider<RankingData>() {
                    @Override
                    public SqlParameterSource createSqlParameterSource(RankingData item) {
                        MapSqlParameterSource parameterSource = new MapSqlParameterSource();
                        parameterSource.addValue("gameId",  SCORES_KEY);
                        parameterSource.addValue("memberId", item.getMemberId());
                        parameterSource.addValue("resultArea", item.getAreaSize());
                        // Redis에서 rank를 얻어와 resultRanking에 저장합니다.  item.getId()?? 이 부분을 고쳐야함
                        Long rank = redisTemplate.opsForZSet().reverseRank("1", item.getMemberId());
                        parameterSource.addValue("resultRanking", rank == null ? null : rank.intValue() + 1);

                        return parameterSource;
                    }
                })
                .build();
    }


}

