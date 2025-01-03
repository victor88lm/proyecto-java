package dao;

import config.DBConnection;
import model.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.OrderStatus;

public class OrderDAO {
    // Consultas SQL
    private static final String INSERT_ORDER = 
        "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)";
    
    private static final String SELECT_ALL_ORDERS = 
        "SELECT o.*, u.username, u.email FROM orders o " +
        "JOIN users u ON o.user_id = u.id " +
        "ORDER BY o.created_at DESC";
    
    private static final String SELECT_ORDER_BY_ID = 
        "SELECT o.*, u.username, u.email FROM orders o " +
        "JOIN users u ON o.user_id = u.id " +
        "WHERE o.id = ?";
    
    private static final String UPDATE_ORDER_STATUS = 
        "UPDATE orders SET status = ? WHERE id = ?";
    
    private static final String SELECT_ORDERS_BY_USER = 
        "SELECT o.*, u.username, u.email FROM orders o " +
        "JOIN users u ON o.user_id = u.id " +
        "WHERE o.user_id = ? " +
        "ORDER BY o.created_at DESC";

    // Insertar nuevo pedido
    public void insertOrder(Order order) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setInt(1, order.getUserId());
            preparedStatement.setBigDecimal(2, order.getTotalAmount());
            preparedStatement.setString(3, order.getStatus());
            
            preparedStatement.executeUpdate();
            
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setId(generatedKeys.getInt(1));
                }
            }
        }
    }
    
    // Obtener todos los pedidos
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet rs = preparedStatement.executeQuery()) {
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }
        
        return orders;
    }
    
    // Obtener pedido por ID
    public Order getOrderById(int id) throws SQLException {
        Order order = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDER_BY_ID)) {
            
            preparedStatement.setInt(1, id);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        }
        
        return order;
    }
    
    // Actualizar estado del pedido
public boolean updateOrderStatus(int id, String status) throws SQLException {
    System.out.println("Ejecutando actualización en DAO:");
    System.out.println("ID: " + id);
    System.out.println("Nuevo status: " + status);
    
    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_ORDER_STATUS)) {
        
        preparedStatement.setString(1, status.trim().toUpperCase());
        preparedStatement.setInt(2, id);
        
        System.out.println("Query a ejecutar: " + preparedStatement.toString());
        
        int result = preparedStatement.executeUpdate();
        System.out.println("Filas afectadas: " + result);
        
        return result > 0;
    } catch (SQLException e) {
        System.out.println("Error en updateOrderStatus: " + e.getMessage());
        throw e;
    }
}
    
    // Obtener pedidos por usuario
    public List<Order> getOrdersByUser(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ORDERS_BY_USER)) {
            
            preparedStatement.setInt(1, userId);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        
        return orders;
    }
    
    // Método auxiliar para mapear ResultSet a Order
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUsername(rs.getString("username"));
        order.setEmail(rs.getString("email"));
        return order;
    }
    
    
}

