package dao;

import config.DBConnection;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // Consultas SQL
    private static final String INSERT_USER = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM users WHERE id = ?";
    private static final String SELECT_ALL_USERS = "SELECT * FROM users";
    private static final String DELETE_USER = "DELETE FROM users WHERE id = ?";
    private static final String UPDATE_USER = "UPDATE users SET username = ?, password = ?, email = ?, role = ? WHERE id = ?";
    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM users WHERE email = ?";
    
    // Insertar nuevo usuario
    public void insertUser(User user) throws SQLException {
    System.out.println("Iniciando inserción de usuario");
    try (Connection connection = DBConnection.getConnection()) {
        System.out.println("Conexión obtenida exitosamente");
        
        try (PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS)) {
            System.out.println("PreparedStatement creado");
            
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getRole());
            
            System.out.println("Ejecutando query: " + preparedStatement.toString());
            preparedStatement.executeUpdate();
            System.out.println("Query ejecutado exitosamente");
            
        } catch (SQLException e) {
            System.out.println("Error en PreparedStatement: " + e.getMessage());
            throw e;
        }
    } catch (SQLException e) {
        System.out.println("Error en conexión: " + e.getMessage());
        throw e;
    }
}
    
    // Obtener usuario por ID
    public User getUserById(int id) throws SQLException {
        User user = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID)) {
            
            preparedStatement.setInt(1, id);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        }
        
        return user;
    }
    
    // Obtener todos los usuarios
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = preparedStatement.executeQuery()) {
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        
        return users;
    }
    
    // Actualizar usuario
    public boolean updateUser(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER)) {
            
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getRole());
            preparedStatement.setInt(5, user.getId());
            
            return preparedStatement.executeUpdate() > 0;
        }
    }
    
    // Eliminar usuario
    public boolean deleteUser(int id) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_USER)) {
            
            preparedStatement.setInt(1, id);
            
            return preparedStatement.executeUpdate() > 0;
        }
    }
    
    // Obtener usuario por email (útil para login)
    public User getUserByEmail(String email) throws SQLException {
        User user = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_EMAIL)) {
            
            preparedStatement.setString(1, email);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        }
        
        return user;
    }
    
    // Método auxiliar para mapear ResultSet a User
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}

