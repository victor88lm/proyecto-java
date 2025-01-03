package model;

public class DashboardStats {
    private int totalUsers;
    private int totalProducts;
    private int totalOrders;
    private double totalSales;

    // Constructor
    public DashboardStats() {
        this.totalUsers = 0;
        this.totalProducts = 0;
        this.totalOrders = 0;
        this.totalSales = 0.0;
    }

    // Getters and Setters
    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(double totalSales) {
        this.totalSales = totalSales;
    }
}