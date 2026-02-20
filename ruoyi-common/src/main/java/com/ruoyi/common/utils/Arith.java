package com.ruoyi.common.utils;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Precise floating-point arithmetic
 * 
 * @author ruoyi
 */
public class Arith
{

    /** Default division precision */
    private static final int DEF_DIV_SCALE = 10;

    /** This class cannot be instantiated */
    private Arith()
    {
    }

    /**
     * Provide precise addition operation
     * @param v1 Augend
     * @param v2 Addend
     * @return Sum of two parameters
     */
    public static double add(double v1, double v2)
    {
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        return b1.add(b2).doubleValue();
    }

    /**
     * Provide precise subtraction operation
     * @param v1 Minuend
     * @param v2 Subtrahend
     * @return Difference of two parameters
     */
    public static double sub(double v1, double v2)
    {
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        return b1.subtract(b2).doubleValue();
    }

    /**
     * Provide precise multiplication operation
     * @param v1 Multiplicand
     * @param v2 Multiplier
     * @return Product of two parameters
     */
    public static double mul(double v1, double v2)
    {
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        return b1.multiply(b2).doubleValue();
    }

    /**
     * Provide (relatively) precise division operation. When division cannot be exact,
     * it is precise to 10 decimal places, and subsequent digits are rounded.
     * @param v1 Dividend
     * @param v2 Divisor
     * @return Quotient of two parameters
     */
    public static double div(double v1, double v2)
    {
        return div(v1, v2, DEF_DIV_SCALE);
    }

    /**
     * Provide (relatively) precise division operation. When division cannot be exact,
     * the precision is specified by the scale parameter, and subsequent digits are rounded.
     * @param v1 Dividend
     * @param v2 Divisor
     * @param scale Indicates the number of decimal places to be precise
     * @return Quotient of two parameters
     */
    public static double div(double v1, double v2, int scale)
    {
        if (scale < 0)
        {
            throw new IllegalArgumentException(
                    "The scale must be a positive integer or zero");
        }
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        if (b1.compareTo(BigDecimal.ZERO) == 0)
        {
            return BigDecimal.ZERO.doubleValue();
        }
        return b1.divide(b2, scale, RoundingMode.HALF_UP).doubleValue();
    }

    /**
     * Provide precise decimal rounding
     * @param v Number to be rounded
     * @param scale Number of decimal places to retain
     * @return Rounded result
     */
    public static double round(double v, int scale)
    {
        if (scale < 0)
        {
            throw new IllegalArgumentException(
                    "The scale must be a positive integer or zero");
        }
        BigDecimal b = new BigDecimal(Double.toString(v));
        return b.divide(BigDecimal.ONE, scale, RoundingMode.HALF_UP).doubleValue();
    }
}
