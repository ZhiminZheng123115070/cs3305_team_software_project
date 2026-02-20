package com.ruoyi.common.utils.bean;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Bean utility class
 * 
 * @author ruoyi
 */
public class BeanUtils extends org.springframework.beans.BeanUtils
{
    /** Starting index of property name in Bean method name */
    private static final int BEAN_METHOD_PROP_INDEX = 3;

    /** Regular expression to match getter methods */
    private static final Pattern GET_PATTERN = Pattern.compile("get(\\p{javaUpperCase}\\w*)");

    /** Regular expression to match setter methods */
    private static final Pattern SET_PATTERN = Pattern.compile("set(\\p{javaUpperCase}\\w*)");

    /**
     * Bean property copy utility method.
     * 
     * @param dest Target object
     * @param src Source object
     */
    public static void copyBeanProp(Object dest, Object src)
    {
        try
        {
            copyProperties(src, dest);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    /**
     * Get setter methods of the object.
     * 
     * @param obj Object
     * @return List of setter methods of the object
     */
    public static List<Method> getSetterMethods(Object obj)
    {
        // List of setter methods
        List<Method> setterMethods = new ArrayList<Method>();

        // Get all methods
        Method[] methods = obj.getClass().getMethods();

        // Find setter methods

        for (Method method : methods)
        {
            Matcher m = SET_PATTERN.matcher(method.getName());
            if (m.matches() && (method.getParameterTypes().length == 1))
            {
                setterMethods.add(method);
            }
        }
        // Return setter method list
        return setterMethods;
    }

    /**
     * Get getter methods of the object.
     * 
     * @param obj Object
     * @return List of getter methods of the object
     */

    public static List<Method> getGetterMethods(Object obj)
    {
        // List of getter methods
        List<Method> getterMethods = new ArrayList<Method>();
        // Get all methods
        Method[] methods = obj.getClass().getMethods();
        // Find getter methods
        for (Method method : methods)
        {
            Matcher m = GET_PATTERN.matcher(method.getName());
            if (m.matches() && (method.getParameterTypes().length == 0))
            {
                getterMethods.add(method);
            }
        }
        // Return getter method list
        return getterMethods;
    }

    /**
     * Check if property names in Bean method names are equal.<br>
     * For example, getName() and setName() have the same property name, getName() and setAge() have different property names.
     * 
     * @param m1 Method name 1
     * @param m2 Method name 2
     * @return Returns true if property names are the same, otherwise returns false
     */

    public static boolean isMethodPropEquals(String m1, String m2)
    {
        return m1.substring(BEAN_METHOD_PROP_INDEX).equals(m2.substring(BEAN_METHOD_PROP_INDEX));
    }
}
