package com.team6.request;

import java.util.ArrayList;
import java.util.List;

/**
 * @author zhimin
 * 2026/2/6 16:08
 */
public class CartListRequest {


    private Integer pageNum= 1;
    private Integer pageSize= 10;

    private List<SortItem> sorts = new ArrayList<>();


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

    public List<SortItem> getSorts() {
        return sorts;
    }

    public void setSorts(List<SortItem> sorts) {
        this.sorts = sorts;
    }
}
