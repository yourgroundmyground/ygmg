package com.ygmg.game.config;

import com.ygmg.game.api.service.GameService;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.data.redis.core.*;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.annotation.PostConstruct;
import javax.sql.DataSource;

@Configuration
@EnableBatchProcessing
public class BatchConfig {

//    private static String SCORES_KEY = "65";
    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;
    private final DataSource dataSource;
    private final RedisTemplate<String, RankingData> redisTemplate;

    private static GameService gameService;

    public BatchConfig(JobBuilderFactory jobBuilderFactory, StepBuilderFactory stepBuilderFactory, DataSource dataSource, @Qualifier("redisBatchTemplate") RedisTemplate<String, RankingData> redisTemplate, GameService gameService){
        this.jobBuilderFactory = jobBuilderFactory;
        this.stepBuilderFactory = stepBuilderFactory;
        this.dataSource = dataSource;
        this.redisTemplate = redisTemplate;
        this.gameService = gameService;
    }
    @Bean
    public NamedParameterJdbcTemplate namedParameterJdbcTemplate() {
        return new NamedParameterJdbcTemplate(dataSource);
    }

    @Bean
    public ItemReader<RankingData> rankingDataReader() {
        return new RedisItemReader();
    }

    public String scoresKey() {
        Long gameId = gameService.getGameId();
        return String.valueOf(gameId);
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

    class RedisItemReader implements ItemReader<RankingData> {
        private Cursor<ZSetOperations.TypedTuple<RankingData>> cursor;
        private boolean cursorOpened = false;
        @PostConstruct
        private void openCursor() {
            this.cursor = redisTemplate.opsForZSet().scan(scoresKey(), ScanOptions.NONE);
        }

        @Override
        public RankingData read() {
            if (!cursorOpened) {
                openCursor();
                cursorOpened = true;
            }
            if(cursor.hasNext()){
                ZSetOperations.TypedTuple<RankingData> tuple = cursor.next();
                RankingData rankingData = tuple.getValue();
                rankingData.setAreaSize(tuple.getScore());
                rankingData.setGameId(scoresKey());
                return rankingData;
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

        return items -> {
            List<Map<String, Object>> batchValues = new ArrayList<>();
            for (RankingData item : items) {
                Map<String, Object> parameters = new HashMap<>();
                System.out.println("scores_key : " + scoresKey());
                parameters.put("gameId", scoresKey());
                parameters.put("memberId", item.getMemberId());
                parameters.put("areaSize", item.getAreaSize());
                Long rank = redisTemplate.opsForZSet().reverseRank(scoresKey(), Integer.valueOf(item.getMemberId()));
                item.setResultRanking(rank.intValue() + 1);
                parameters.put("resultRanking", item.getResultRanking());
                batchValues.add(parameters);
            }
            namedParameterJdbcTemplate().batchUpdate("INSERT INTO result (game_id, member_id, result_area, result_ranking) VALUES (:gameId, :memberId, :areaSize, :resultRanking)", batchValues.toArray(new Map[batchValues.size()]));
        };
    }

}
