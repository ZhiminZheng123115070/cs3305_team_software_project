package com.ruoyi.framework.config;

import java.util.TimeZone;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * Application annotation configuration
 *
 * @author ruoyi
 */
@Configuration
// Expose proxy object through AOP framework, AopContext can access
@EnableAspectJAutoProxy(exposeProxy = true)
// Specify the package path to scan Mapper classes
@MapperScan({"com.ruoyi.**.mapper", "com.team6.mapper"})
public class ApplicationConfig
{
    /**
     * Timezone configuration
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jacksonObjectMapperCustomization()
    {
        return jacksonObjectMapperBuilder -> jacksonObjectMapperBuilder.timeZone(TimeZone.getDefault());
    }
}
