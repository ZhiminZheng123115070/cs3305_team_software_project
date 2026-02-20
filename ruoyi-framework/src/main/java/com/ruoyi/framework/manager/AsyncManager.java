package com.ruoyi.framework.manager;

import java.util.TimerTask;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import com.ruoyi.common.utils.Threads;
import com.ruoyi.common.utils.spring.SpringUtils;

/**
 * Asynchronous task manager
 * 
 * @author ruoyi
 */
public class AsyncManager
{
    /**
     * Operation delay of 10 milliseconds
     */
    private final int OPERATE_DELAY_TIME = 10;

    /**
     * Asynchronous operation task scheduling thread pool
     */
    private ScheduledExecutorService executor = SpringUtils.getBean("scheduledExecutorService");

    /**
     * Singleton pattern
     */
    private AsyncManager(){}

    private static AsyncManager me = new AsyncManager();

    public static AsyncManager me()
    {
        return me;
    }

    /**
     * Execute task
     * 
     * @param task Task
     */
    public void execute(TimerTask task)
    {
        executor.schedule(task, OPERATE_DELAY_TIME, TimeUnit.MILLISECONDS);
    }

    /**
     * Stop task thread pool
     */
    public void shutdown()
    {
        Threads.shutdownAndAwaitTermination(executor);
    }
}
