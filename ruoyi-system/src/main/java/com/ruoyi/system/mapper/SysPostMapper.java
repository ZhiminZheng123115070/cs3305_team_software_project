package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysPost;

/**
 * Post Information Data Layer
 * 
 * @author ruoyi
 */
public interface SysPostMapper
{
    /**
     * Query Post Data Collection
     * 
     * @param post Post Information
     * @return Post Data Collection
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
     * Query User Post Group
     * 
     * @param userName Username
     * @return Result
     */
    public List<SysPost> selectPostsByUserName(String userName);

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
     * Modify Post Information
     * 
     * @param post Post Information
     * @return Result
     */
    public int updatePost(SysPost post);

    /**
     * Add Post Information
     * 
     * @param post Post Information
     * @return Result
     */
    public int insertPost(SysPost post);

    /**
     * Validate Post Name
     * 
     * @param postName Post Name
     * @return Result
     */
    public SysPost checkPostNameUnique(String postName);

    /**
     * Validate Post Code
     * 
     * @param postCode Post Code
     * @return Result
     */
    public SysPost checkPostCodeUnique(String postCode);
}
