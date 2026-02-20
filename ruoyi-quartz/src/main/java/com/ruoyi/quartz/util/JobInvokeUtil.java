package com.ruoyi.quartz.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.LinkedList;
import java.util.List;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.quartz.domain.SysJob;

/**
 * Task Execution Utility
 *
 * @author ruoyi
 */
public class JobInvokeUtil
{
    /**
     * Execute method
     *
     * @param sysJob System task
     */
    public static void invokeMethod(SysJob sysJob) throws Exception
    {
        String invokeTarget = sysJob.getInvokeTarget();
        String beanName = getBeanName(invokeTarget);
        String methodName = getMethodName(invokeTarget);
        List<Object[]> methodParams = getMethodParams(invokeTarget);

        if (!isValidClassName(beanName))
        {
            Object bean = SpringUtils.getBean(beanName);
            invokeMethod(bean, methodName, methodParams);
        }
        else
        {
            Object bean = Class.forName(beanName).getDeclaredConstructor().newInstance();
            invokeMethod(bean, methodName, methodParams);
        }
    }

    /**
     * Invoke task method
     *
     * @param bean Target object
     * @param methodName Method name
     * @param methodParams Method parameters
     */
    private static void invokeMethod(Object bean, String methodName, List<Object[]> methodParams)
            throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException,
            InvocationTargetException
    {
        if (StringUtils.isNotNull(methodParams) && methodParams.size() > 0)
        {
            Method method = bean.getClass().getMethod(methodName, getMethodParamsType(methodParams));
            method.invoke(bean, getMethodParamsValue(methodParams));
        }
        else
        {
            Method method = bean.getClass().getMethod(methodName);
            method.invoke(bean);
        }
    }

    /**
     * Validate if it is a class package name
     * 
     * @param invokeTarget Name
     * @return true yes false no
     */
    public static boolean isValidClassName(String invokeTarget)
    {
        return StringUtils.countMatches(invokeTarget, ".") > 1;
    }

    /**
     * Get bean name
     * 
     * @param invokeTarget Target string
     * @return Bean name
     */
    public static String getBeanName(String invokeTarget)
    {
        String beanName = StringUtils.substringBefore(invokeTarget, "(");
        return StringUtils.substringBeforeLast(beanName, ".");
    }

    /**
     * Get bean method
     * 
     * @param invokeTarget Target string
     * @return Method
     */
    public static String getMethodName(String invokeTarget)
    {
        String methodName = StringUtils.substringBefore(invokeTarget, "(");
        return StringUtils.substringAfterLast(methodName, ".");
    }

    /**
     * Get method parameter related list
     * 
     * @param invokeTarget Target string
     * @return Method parameter related list
     */
    public static List<Object[]> getMethodParams(String invokeTarget)
    {
        String methodStr = StringUtils.substringBetweenLast(invokeTarget, "(", ")");
        if (StringUtils.isEmpty(methodStr))
        {
            return null;
        }
        String[] methodParams = methodStr.split(",(?=([^\"']*[\"'][^\"']*[\"'])*[^\"']*$)");
        List<Object[]> classs = new LinkedList<>();
        for (int i = 0; i < methodParams.length; i++)
        {
            String str = StringUtils.trimToEmpty(methodParams[i]);
            // String type, starts with ' or "
            if (StringUtils.startsWithAny(str, "'", "\""))
            {
                classs.add(new Object[] { StringUtils.substring(str, 1, str.length() - 1), String.class });
            }
            // boolean type, equals true or false
            else if ("true".equalsIgnoreCase(str) || "false".equalsIgnoreCase(str))
            {
                classs.add(new Object[] { Boolean.valueOf(str), Boolean.class });
            }
            // long type, ends with L
            else if (StringUtils.endsWith(str, "L"))
            {
                classs.add(new Object[] { Long.valueOf(StringUtils.substring(str, 0, str.length() - 1)), Long.class });
            }
            // double type, ends with D
            else if (StringUtils.endsWith(str, "D"))
            {
                classs.add(new Object[] { Double.valueOf(StringUtils.substring(str, 0, str.length() - 1)), Double.class });
            }
            // Other types classified as integer
            else
            {
                classs.add(new Object[] { Integer.valueOf(str), Integer.class });
            }
        }
        return classs;
    }

    /**
     * Get parameter types
     * 
     * @param methodParams Parameter related list
     * @return Parameter type list
     */
    public static Class<?>[] getMethodParamsType(List<Object[]> methodParams)
    {
        Class<?>[] classs = new Class<?>[methodParams.size()];
        int index = 0;
        for (Object[] os : methodParams)
        {
            classs[index] = (Class<?>) os[1];
            index++;
        }
        return classs;
    }

    /**
     * Get parameter values
     * 
     * @param methodParams Parameter related list
     * @return Parameter value list
     */
    public static Object[] getMethodParamsValue(List<Object[]> methodParams)
    {
        Object[] classs = new Object[methodParams.size()];
        int index = 0;
        for (Object[] os : methodParams)
        {
            classs[index] = (Object) os[0];
            index++;
        }
        return classs;
    }
}
