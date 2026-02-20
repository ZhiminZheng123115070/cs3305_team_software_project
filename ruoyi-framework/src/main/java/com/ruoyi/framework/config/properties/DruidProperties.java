package com.ruoyi.framework.config.properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import com.alibaba.druid.pool.DruidDataSource;

/**
 * Druid configuration properties
 * 
 * @author ruoyi
 */
@Configuration
public class DruidProperties
{
    @Value("${spring.datasource.druid.initialSize}")
    private int initialSize;

    @Value("${spring.datasource.druid.minIdle}")
    private int minIdle;

    @Value("${spring.datasource.druid.maxActive}")
    private int maxActive;

    @Value("${spring.datasource.druid.maxWait}")
    private int maxWait;

    @Value("${spring.datasource.druid.connectTimeout}")
    private int connectTimeout;

    @Value("${spring.datasource.druid.socketTimeout}")
    private int socketTimeout;

    @Value("${spring.datasource.druid.timeBetweenEvictionRunsMillis}")
    private int timeBetweenEvictionRunsMillis;

    @Value("${spring.datasource.druid.minEvictableIdleTimeMillis}")
    private int minEvictableIdleTimeMillis;

    @Value("${spring.datasource.druid.maxEvictableIdleTimeMillis}")
    private int maxEvictableIdleTimeMillis;

    @Value("${spring.datasource.druid.validationQuery}")
    private String validationQuery;

    @Value("${spring.datasource.druid.testWhileIdle}")
    private boolean testWhileIdle;

    @Value("${spring.datasource.druid.testOnBorrow}")
    private boolean testOnBorrow;

    @Value("${spring.datasource.druid.testOnReturn}")
    private boolean testOnReturn;

    public DruidDataSource dataSource(DruidDataSource datasource)
    {
        /** Configure initial size, minimum, maximum */
        datasource.setInitialSize(initialSize);
        datasource.setMaxActive(maxActive);
        datasource.setMinIdle(minIdle);

        /** Configure connection wait timeout */
        datasource.setMaxWait(maxWait);
        
        /** Configure driver connection timeout, detect database connection establishment timeout, unit is milliseconds */
        datasource.setConnectTimeout(connectTimeout);
        
        /** Configure network timeout, wait for database operation completion network timeout, unit is milliseconds */
        datasource.setSocketTimeout(socketTimeout);

        /** Configure interval for idle connection check, unit is milliseconds */
        datasource.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);

        /** Configure minimum and maximum connection lifetime in pool, unit is milliseconds */
        datasource.setMinEvictableIdleTimeMillis(minEvictableIdleTimeMillis);
        datasource.setMaxEvictableIdleTimeMillis(maxEvictableIdleTimeMillis);

        /**
         * SQL used to detect if connection is valid, must be a query statement, commonly used select 'x'. If validationQuery is null, testOnBorrow, testOnReturn, testWhileIdle will not work.
         */
        datasource.setValidationQuery(validationQuery);
        /** Recommended to set to true, does not affect performance and ensures security. Check when applying for connection, if idle time is greater than timeBetweenEvictionRunsMillis, execute validationQuery to check if connection is valid. */
        datasource.setTestWhileIdle(testWhileIdle);
        /** Execute validationQuery to check if connection is valid when applying for connection, this configuration will reduce performance. */
        datasource.setTestOnBorrow(testOnBorrow);
        /** Execute validationQuery to check if connection is valid when returning connection, this configuration will reduce performance. */
        datasource.setTestOnReturn(testOnReturn);
        return datasource;
    }
}
