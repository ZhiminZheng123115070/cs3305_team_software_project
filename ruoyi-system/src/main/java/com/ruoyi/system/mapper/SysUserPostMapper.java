package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysUserPost;

/**
 * User and Post Association Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysUserPostMapper
{
    /**
     * Delete User and Post Association by User ID
     * 
     * @param userId User ID
     * @return Result
     */
    public int deleteUserPostByUserId(Long userId);

    /**
     * Query Post Usage Count by Post ID
     * 
     * @param postId Post ID
     * @return Result
     */
    public int countUserPostById(Long postId);

    /**
     * Batch Delete User and Post Associations
     * 
     * @param ids Data IDs to Delete
     * @return Result
     */
    public int deleteUserPost(Long[] ids);

    /**
     * Batch Add User Post Information
     * 
     * @param userPostList User Post List
     * @return Result
     */
    public int batchUserPost(List<SysUserPost> userPostList);
}
