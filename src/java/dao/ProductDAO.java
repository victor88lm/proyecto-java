package dao;

import config.DBConnection;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    // Consultas SQL
    private static final String INSERT_PRODUCT = "INSERT INTO products (name, description, price, stock, image_url) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_PRODUCT_BY_ID = "SELECT * FROM products WHERE id = ?";
    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM products";
    private static final String UPDATE_PRODUCT = "UPDATE products SET name = ?, description = ?, price = ?, stock = ?, image_url = ? WHERE id = ?";
        private static final String DELETE_ORDER_DETAILS = "DELETE FROM order_details WHERE product_id = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM products WHERE id = ?";
    
    // Insertar nuevo producto
    public void insertProduct(Product product) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PRODUCT, Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setString(1, product.getName());
            preparedStatement.setString(2, product.getDescription());
            preparedStatement.setBigDecimal(3, product.getPrice());
            preparedStatement.setInt(4, product.getStock());
            preparedStatement.setString(5, product.getImageUrl());
            
            preparedStatement.executeUpdate();
            
            // Obtener el ID generado
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    product.setId(generatedKeys.getInt(1));
                }
            }
        }
    }
    
    // Obtener producto por ID
    public Product getProductById(int id) throws SQLException {
        Product product = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PRODUCT_BY_ID)) {
            
            preparedStatement.setInt(1, id);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    product = mapResultSetToProduct(rs);
                }
            }
        }
        
        return product;
    }
    
    // Obtener todos los productos
    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_PRODUCTS);
             ResultSet rs = preparedStatement.executeQuery()) {
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        }
        
        return products;
    }
    
    // Actualizar producto
    public boolean updateProduct(Product product) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_PRODUCT)) {
            
            preparedStatement.setString(1, product.getName());
            preparedStatement.setString(2, product.getDescription());
            preparedStatement.setBigDecimal(3, product.getPrice());
            preparedStatement.setInt(4, product.getStock());
            preparedStatement.setString(5, product.getImageUrl());
            preparedStatement.setInt(6, product.getId());
            
            return preparedStatement.executeUpdate() > 0;
        }
    }
    
    // Eliminar producto
    public boolean deleteProduct(int id) throws SQLException {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false); // Iniciar transacción
            
            // Primero eliminar los detalles de órdenes relacionados
            try (PreparedStatement deleteDetails = connection.prepareStatement(DELETE_ORDER_DETAILS)) {
                deleteDetails.setInt(1, id);
                deleteDetails.executeUpdate();
            }
            
            // Luego eliminar el producto
            try (PreparedStatement deleteProduct = connection.prepareStatement(DELETE_PRODUCT)) {
                deleteProduct.setInt(1, id);
                int result = deleteProduct.executeUpdate();
                connection.commit(); // Confirmar transacción
                return result > 0;
            }
            
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback(); // Deshacer cambios si hay error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    
    // Método auxiliar para mapear ResultSet a Product
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        return product;
    }
}