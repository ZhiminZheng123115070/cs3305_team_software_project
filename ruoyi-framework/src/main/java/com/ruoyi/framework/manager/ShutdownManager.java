package com.ruoyi.framework.manager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import javax.annotation.PreDestroy;

/**
 * Ensure background threads are closed when the application exits
 *
 * @author ruoyi
 */
@Component
public class ShutdownManager
{
    private static final Logger logger = LoggerFactory.getLogger("sys-user");

    @PreDestroy
    public void destroy()
    {
        shutdownAsyncManager();
    }

    /**
     * Stop asynchronous execution tasks
     */
    private void shutdownAsyncManager()
    {
        try
        {
            logger.info("====Shutting down background task thread pool====");
            AsyncManager.me().shutdown();
        }
        catch (Exception e)
        {
            logger.error(e.getMessage(), e);
        }
    }
}
