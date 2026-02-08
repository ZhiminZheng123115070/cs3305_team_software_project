package com.team6.request;

/**
 * @author zhimin
 * 2026/2/6 17:25
 */
public class SortItem {

    private String field;

    private String order="asc";


    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }
}
