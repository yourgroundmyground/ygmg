package com.ygmg.game.config;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
@EnableScheduling
public class SchedulerConfig {
    private final JobLauncher jobLauncher;
    private final Job migrateRankingJob;

    public SchedulerConfig(JobLauncher jobLauncher, Job migrateRankingJob) {
        this.jobLauncher = jobLauncher;
        this.migrateRankingJob = migrateRankingJob;
    }

//    @Scheduled(cron = "0 50 23 * * 0") // 매주 일요일 23시 50분에 작업 실행
    @Scheduled(cron = "0 18 17 * * *")
    public void runMigrateRankingJob() throws Exception {
        JobParameters params = new JobParametersBuilder()
                .addString("JobID", String.valueOf(System.currentTimeMillis()))
                .toJobParameters();
        jobLauncher.run(migrateRankingJob, params);
    }
}