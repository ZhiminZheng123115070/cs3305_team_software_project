package com.team6.request;

/**
 * @author zhimin
 * 2026/2/17 18:38
 */
public class StorageListRequest {
    private Integer pageNum= 1;
    private Integer pageSize= 10;
    private Long userId;

    public Integer getPageNum() {
        return pageNum;
    }

    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
