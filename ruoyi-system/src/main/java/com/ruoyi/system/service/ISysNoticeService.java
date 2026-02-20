package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysNotice;

/**
 * Notice Service Layer
 * 
 * @author ruoyi
 */
public interface ISysNoticeService
{
    /**
     * Query Notice Information
     * 
     * @param noticeId Notice ID
     * @return Notice Information
     */
    public SysNotice selectNoticeById(Long noticeId);

    /**
     * Query Notice List
     * 
     * @param notice Notice Information
     * @return Notice Collection
     */
    public List<SysNotice> selectNoticeList(SysNotice notice);

    /**
     * Add Notice
     * 
     * @param notice Notice Information
     * @return Result
     */
    public int insertNotice(SysNotice notice);

    /**
     * Modify Notice
     * 
     * @param notice Notice Information
     * @return Result
     */
    public int updateNotice(SysNotice notice);

    /**
     * Delete Notice Information
     * 
     * @param noticeId Notice ID
     * @return Result
     */
    public int deleteNoticeById(Long noticeId);
    
    /**
     * Batch Delete Notice Information
     * 
     * @param noticeIds Notice IDs to Delete
     * @return Result
     */
    public int deleteNoticeByIds(Long[] noticeIds);
}
