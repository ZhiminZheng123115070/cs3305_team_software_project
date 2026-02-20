package com.ruoyi.common.utils.uuid;

import java.util.concurrent.atomic.AtomicInteger;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;

/**
 * @author ruoyi Sequence Generation Class
 */
public class Seq
{
    // Common sequence type
    public static final String commSeqType = "COMMON";

    // Upload sequence type
    public static final String uploadSeqType = "UPLOAD";

    // Common interface sequence number
    private static AtomicInteger commSeq = new AtomicInteger(1);

    // Upload interface sequence number
    private static AtomicInteger uploadSeq = new AtomicInteger(1);

    // Machine identifier
    private static final String machineCode = "A";

    /**
     * Get common sequence number
     * 
     * @return Sequence value
     */
    public static String getId()
    {
        return getId(commSeqType);
    }
    
    /**
     * Default 16-bit sequence number yyMMddHHmmss + one machine identifier + 3-length circular increment string
     * 
     * @return Sequence value
     */
    public static String getId(String type)
    {
        AtomicInteger atomicInt = commSeq;
        if (uploadSeqType.equals(type))
        {
            atomicInt = uploadSeq;
        }
        return getId(atomicInt, 3);
    }

    /**
     * Common interface sequence number yyMMddHHmmss + one machine identifier + length-length circular increment string
     * 
     * @param atomicInt Sequence number
     * @param length Value length
     * @return Sequence value
     */
    public static String getId(AtomicInteger atomicInt, int length)
    {
        String result = DateUtils.dateTimeNow();
        result += machineCode;
        result += getSeq(atomicInt, length);
        return result;
    }

    /**
     * Sequence circular increment string [1, 10 to the power of (length)), pad left with 0 to length digits
     * 
     * @return Sequence value
     */
    private synchronized static String getSeq(AtomicInteger atomicInt, int length)
    {
        // Get value first then +1
        int value = atomicInt.getAndIncrement();

        // If updated value >= 10 to the power of (length) then reset to 1
        int maxSeq = (int) Math.pow(10, length);
        if (atomicInt.get() >= maxSeq)
        {
            atomicInt.set(1);
        }
        // Convert to string, pad left with 0
        return StringUtils.padl(value, length);
    }
}
