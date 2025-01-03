package model;

public enum OrderStatus {
    PENDING("PENDING"), 
    PROCESSING("PROCESSING"), 
    COMPLETED("COMPLETED"), 
    CANCELLED("CANCELLED");

    private final String value;

    OrderStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}