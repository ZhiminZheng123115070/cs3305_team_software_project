//package com.ruoyi.quartz.config;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.scheduling.quartz.SchedulerFactoryBean;
//import javax.sql.DataSource;
//import java.util.Properties;
//
///**
// * Scheduled Task Configuration (For single machine deployment, it is recommended to delete this class and qrtz database tables, default memory mode will be most efficient)
// * 
// * @author ruoyi
// */
//@Configuration
//public class ScheduleConfig
//{
//    @Bean
//    public SchedulerFactoryBean schedulerFactoryBean(DataSource dataSource)
//    {
//        SchedulerFactoryBean factory = new SchedulerFactoryBean();
//        factory.setDataSource(dataSource);
//
//        // Quartz parameters
//        Properties prop = new Properties();
//        prop.put("org.quartz.scheduler.instanceName", "RuoyiScheduler");
//        prop.put("org.quartz.scheduler.instanceId", "AUTO");
//        // Thread pool configuration
//        prop.put("org.quartz.threadPool.class", "org.quartz.simpl.SimpleThreadPool");
//        prop.put("org.quartz.threadPool.threadCount", "20");
//        prop.put("org.quartz.threadPool.threadPriority", "5");
//        // JobStore configuration
//        prop.put("org.quartz.jobStore.class", "org.springframework.scheduling.quartz.LocalDataSourceJobStore");
//        // Cluster configuration
//        prop.put("org.quartz.jobStore.isClustered", "true");
//        prop.put("org.quartz.jobStore.clusterCheckinInterval", "15000");
//        prop.put("org.quartz.jobStore.maxMisfiresToHandleAtATime", "10");
//        prop.put("org.quartz.jobStore.txIsolationLevelSerializable", "true");
//
//        // SQL Server enabled
//        // prop.put("org.quartz.jobStore.selectWithLockSQL", "SELECT * FROM {0}LOCKS UPDLOCK WHERE LOCK_NAME = ?");
//        prop.put("org.quartz.jobStore.misfireThreshold", "12000");
//        prop.put("org.quartz.jobStore.tablePrefix", "QRTZ_");
//        factory.setQuartzProperties(prop);
//
//        factory.setSchedulerName("RuoyiScheduler");
//        // Delayed startup
//        factory.setStartupDelay(1);
//        factory.setApplicationContextSchedulerContextKey("applicationContextKey");
//        // Optional, QuartzScheduler
//        // Update existing jobs on startup, so there's no need to delete corresponding records in qrtz_job_details table after modifying targetObject each time
//        factory.setOverwriteExistingJobs(true);
//        // Set auto startup, default is true
//        factory.setAutoStartup(true);
//
//        return factory;
//    }
//}
