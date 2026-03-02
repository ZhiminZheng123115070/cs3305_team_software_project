package com.team6.response;

/**
 * Result of adding a cart item to order.
 * When product is unknown (missing nutrition), order is still created but item is not added to storage.
 */
public class AddOrderResult {
    private boolean orderAdded;
    private boolean storageAdded;

    public AddOrderResult(boolean orderAdded, boolean storageAdded) {
        this.orderAdded = orderAdded;
        this.storageAdded = storageAdded;
    }

    public boolean isOrderAdded() {
        return orderAdded;
    }

    public void setOrderAdded(boolean orderAdded) {
        this.orderAdded = orderAdded;
    }

    public boolean isStorageAdded() {
        return storageAdded;
    }

    public void setStorageAdded(boolean storageAdded) {
        this.storageAdded = storageAdded;
    }
}
