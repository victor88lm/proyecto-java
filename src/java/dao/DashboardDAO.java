package dao;

import config.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DashboardStats;
import model.OrderDTO;

public class DashboardDAO {
    private static final String COUNT_USERS = "SELECT COUNT(*) FROM users";
    private static final String COUNT_PRODUCTS = "SELECT COUNT(*) FROM products";
    private static final String COUNT_ORDERS = "SELECT COUNT(*) FROM orders";
    private static final String SUM_TOTAL_SALES = "SELECT COALESCE(SUM(total_amount), 0) FROM orders";
    private static final String RECENT_ORDERS = 
        "SELECT o.*, u.username, u.email FROM orders o " +
        "JOIN users u ON o.user_id = u.id " +
        "ORDER BY o.created_at DESC LIMIT 5";

    public DashboardStats getDashboardStats() throws SQLException {
        DashboardStats stats = new DashboardStats();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Obtener número de usuarios
            try (PreparedStatement pst = conn.prepareStatement(COUNT_USERS)) {
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    stats.setTotalUsers(rs.getInt(1));
                }
            }
            
            // Obtener número de productos
            try (PreparedStatement pst = conn.prepareStatement(COUNT_PRODUCTS)) {
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    stats.setTotalProducts(rs.getInt(1));
                }
            }
            
            // Obtener número de pedidos
            try (PreparedStatement pst = conn.prepareStatement(COUNT_ORDERS)) {
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    stats.setTotalOrders(rs.getInt(1));
                }
            }
            
            // Obtener total de ventas
            try (PreparedStatement pst = conn.prepareStatement(SUM_TOTAL_SALES)) {
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    stats.setTotalSales(rs.getDouble(1));
                }
            }
        }
        return stats;
    }

    public List<OrderDTO> getRecentOrders() throws SQLException {
        List<OrderDTO> orders = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(RECENT_ORDERS)) {
            
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                OrderDTO order = new OrderDTO();
                order.setId(rs.getInt("id"));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        }
        return orders;
    }
}