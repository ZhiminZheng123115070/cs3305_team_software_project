package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysPost;

/**
 * Post Information Service Layer
 * 
 * @author ruoyi
 */
public interface ISysPostService
{
    /**
     * Query Post Information Collection
     * 
     * @param post Post Information
     * @return Post List
     */
    public List<SysPost> selectPostList(SysPost post);

    /**
     * Query All Posts
     * 
     * @return Post List
     */
    public List<SysPost> selectPostAll();

    /**
     * Query Post Information by Post ID
     * 
     * @param postId Post ID
     * @return Role Object Information
     */
    public SysPost selectPostById(Long postId);

    /**
     * Get Post Select Box List by User ID
     * 
     * @param userId User ID
     * @return Selected Post ID List
     */
    public List<Long> selectPostListByUserId(Long userId);

    /**
     * Validate Post Name
     * 
     * @param post Post Information
     * @return Result
     */
    public boolean checkPostNameUnique(SysPost post);

    /**
     * Validate Post Code
     * 
     * @param post Post Information
     * @return Result
     */
    public boolean checkPostCodeUnique(SysPost post);

    /**
     * Query Post Usage Count by Post ID
     * 
     * @param postId Post ID
     * @return Result
     */
    public int countUserPostById(Long postId);

    /**
     * Delete Post Information
     * 
     * @param postId Post ID
     * @return Result
     */
    public int deletePostById(Long postId);

    /**
     * Batch Delete Post Information
     * 
     * @param postIds Post IDs to Delete
     * @return Result
     */
    public int deletePostByIds(Long[] postIds);

    /**
     * Add and Save Post Information
     * 
     * @param post Post Information
     * @return Result
     */
    public int insertPost(SysPost post);

    /**
     * Modify and Save Post Information
     * 
     * @param post Post Information
     * @return Result
     */
    public int updatePost(SysPost post);
}
