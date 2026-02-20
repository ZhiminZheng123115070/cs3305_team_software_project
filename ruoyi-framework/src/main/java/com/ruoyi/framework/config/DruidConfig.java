package com.ruoyi.framework.config;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.WriteListener;
import javax.sql.DataSource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceBuilder;
import com.alibaba.druid.spring.boot.autoconfigure.properties.DruidStatProperties;
import com.alibaba.druid.util.Utils;
import com.ruoyi.common.enums.DataSourceType;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.framework.config.properties.DruidProperties;
import com.ruoyi.framework.datasource.DynamicDataSource;

/**
 * Druid multi-datasource configuration
 * 
 * @author ruoyi
 */
@Configuration
public class DruidConfig
{
    @Bean
    @ConfigurationProperties("spring.datasource.druid.master")
    public DataSource masterDataSource(DruidProperties druidProperties)
    {
        DruidDataSource dataSource = DruidDataSourceBuilder.create().build();
        return druidProperties.dataSource(dataSource);
    }

    @Bean
    @ConfigurationProperties("spring.datasource.druid.slave")
    @ConditionalOnProperty(prefix = "spring.datasource.druid.slave", name = "enabled", havingValue = "true")
    public DataSource slaveDataSource(DruidProperties druidProperties)
    {
        DruidDataSource dataSource = DruidDataSourceBuilder.create().build();
        return druidProperties.dataSource(dataSource);
    }

    @Bean(name = "dynamicDataSource")
    @Primary
    public DynamicDataSource dataSource(DataSource masterDataSource)
    {
        Map<Object, Object> targetDataSources = new HashMap<>();
        targetDataSources.put(DataSourceType.MASTER.name(), masterDataSource);
        setDataSource(targetDataSources, DataSourceType.SLAVE.name(), "slaveDataSource");
        return new DynamicDataSource(masterDataSource, targetDataSources);
    }
    
    /**
     * Set datasource
     * 
     * @param targetDataSources Alternative datasource collection
     * @param sourceName Datasource name
     * @param beanName Bean name
     */
    public void setDataSource(Map<Object, Object> targetDataSources, String sourceName, String beanName)
    {
        try
        {
            DataSource dataSource = SpringUtils.getBean(beanName);
            targetDataSources.put(sourceName, dataSource);
        }
        catch (Exception e)
        {
        }
    }

    /**
     * Remove advertisement at the bottom of monitoring page
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Bean
    @ConditionalOnProperty(name = "spring.datasource.druid.statViewServlet.enabled", havingValue = "true")
    public FilterRegistrationBean removeDruidFilterRegistrationBean(DruidStatProperties properties)
    {
        // Get web monitoring page parameters
        DruidStatProperties.StatViewServlet config = properties.getStatViewServlet();
        // Extract common.js configuration path
        String pattern = config.getUrlPattern() != null ? config.getUrlPattern() : "/druid/*";
        String commonJsPattern = pattern.replaceAll("\\*", "js/common.js");
        final String filePath = "support/http/resources/js/common.js";
        // Create filter for filtering
        Filter filter = new Filter()
        {
            @Override
            public void init(javax.servlet.FilterConfig filterConfig) throws ServletException
            {
            }
            @Override
            public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                    throws IOException, ServletException
            {
                chain.doFilter(request, response);
                // Reset buffer, response headers will not be reset
                response.resetBuffer();
                // Get common.js
                String text = Utils.readFromResource(filePath);
                // Regex replace banner, remove advertisement information at the bottom
                text = text.replaceAll("<a.*?banner\"></a><br/>", "");
                text = text.replaceAll("powered.*?shrek.wang</a>", "");
                response.getWriter().write(text);
            }
            @Override
            public void destroy()
            {
            }
        };
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        registrationBean.addUrlPatterns(commonJsPattern);
        return registrationBean;
    }

    /**
     * Translate Druid login page from Chinese to English
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Bean
    @ConditionalOnProperty(name = "spring.datasource.druid.statViewServlet.enabled", havingValue = "true")
    public FilterRegistrationBean druidLoginPageTranslationFilter(DruidStatProperties properties)
    {
        // Get web monitoring page parameters
        DruidStatProperties.StatViewServlet config = properties.getStatViewServlet();
        // Extract login.html path
        String pattern = config.getUrlPattern() != null ? config.getUrlPattern() : "/druid/*";
        String loginHtmlPattern = pattern.replaceAll("\\*", "login.html");
        
        Filter filter = new Filter()
        {
            @Override
            public void init(javax.servlet.FilterConfig filterConfig) throws ServletException
            {
            }
            
            @Override
            public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                    throws IOException, ServletException
            {
                HttpServletResponse httpResponse = (HttpServletResponse) response;
                BufferingResponseWrapper wrapper = new BufferingResponseWrapper(httpResponse);
                chain.doFilter(request, wrapper);

                String charset = httpResponse.getCharacterEncoding();
                if (charset == null || charset.isEmpty())
                {
                    charset = "UTF-8";
                }

                String text = wrapper.getContentAsString(charset);
                // Translate Chinese placeholders/buttons to English
                String translated = text.replace("用户名", "Username")
                        .replace("密码", "Password")
                        .replace("登录", "Sign in")
                        .replace("重置", "Reset");

                // Write back translated HTML
                httpResponse.resetBuffer();
                httpResponse.getWriter().write(translated);
            }
            
            @Override
            public void destroy()
            {
            }
        };
        
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        registrationBean.addUrlPatterns(loginHtmlPattern);
        registrationBean.setOrder(1); // Set higher priority
        return registrationBean;
    }

    /**
     * Response wrapper that captures written content (writer/outputStream) so we can post-process it.
     */
    private static class BufferingResponseWrapper extends HttpServletResponseWrapper
    {
        private final ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        private PrintWriter writer;
        private ServletOutputStream outputStream;

        BufferingResponseWrapper(HttpServletResponse response)
        {
            super(response);
        }

        @Override
        public ServletOutputStream getOutputStream() throws IOException
        {
            if (writer != null)
            {
                throw new IllegalStateException("getWriter() has already been called on this response.");
            }
            if (outputStream == null)
            {
                outputStream = new ServletOutputStream()
                {
                    @Override
                    public boolean isReady()
                    {
                        return true;
                    }

                    @Override
                    public void setWriteListener(WriteListener writeListener)
                    {
                        // no-op
                    }

                    @Override
                    public void write(int b) throws IOException
                    {
                        buffer.write(b);
                    }
                };
            }
            return outputStream;
        }

        @Override
        public PrintWriter getWriter() throws IOException
        {
            if (outputStream != null)
            {
                throw new IllegalStateException("getOutputStream() has already been called on this response.");
            }
            if (writer == null)
            {
                String encoding = getCharacterEncoding();
                if (encoding == null || encoding.isEmpty())
                {
                    encoding = "UTF-8";
                }
                writer = new PrintWriter(new OutputStreamWriter(buffer, encoding), true);
            }
            return writer;
        }

        String getContentAsString(String charset) throws IOException
        {
            if (writer != null)
            {
                writer.flush();
            }
            return buffer.toString(charset);
        }
    }
}
