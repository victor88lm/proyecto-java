package controller;

import dao.ProductDAO;
import java.io.File;
import model.Product;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.util.UUID;

@WebServlet("/product/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        try {
            switch (action) {
                case "/insert":
                    insertProduct(request, response);
                    break;
                case "/update":
                    updateProduct(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        try {
            if ("/delete".equals(action)) {
                deleteProduct(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

private void insertProduct(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException, ServletException {
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    BigDecimal price = new BigDecimal(request.getParameter("price"));
    int stock = Integer.parseInt(request.getParameter("stock"));
    
    // Manejo de la imagen
    Part filePart = request.getPart("image");
    String imageUrl = null;
    
    if (filePart != null && filePart.getSize() > 0) {
        // Obtener el directorio real donde se guardarán las imágenes
        String uploadDir = request.getServletContext().getRealPath("/uploads");
        File uploadDirectory = new File(uploadDir);
        
        // Si el directorio no existe, créalo
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdir();
        }

        // Generar nombre único para el archivo
        String fileName = UUID.randomUUID().toString() + getFileExtension(filePart.getSubmittedFileName());
        String filePath = uploadDir + File.separator + fileName;
        
        System.out.println("Guardando archivo en: " + filePath); // Debug

        // Guardar el archivo
        try {
            filePart.write(filePath);
            imageUrl = "uploads/" + fileName;
        } catch (Exception e) {
            System.out.println("Error al guardar el archivo: " + e.getMessage());
            e.printStackTrace();
        }
    }

    Product newProduct = new Product(name, description, price, stock, imageUrl);
    productDAO.insertProduct(newProduct);
    response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
}

// El método updateProduct también necesita actualizaciones similares
private void updateProduct(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException, ServletException {
    // ... código existente ...
    
    Part filePart = request.getPart("image");
    if (filePart != null && filePart.getSize() > 0) {
        Object imageUrl = null;
        // Eliminar imagen anterior si existe
        if (imageUrl != null) {
            String oldImagePath = request.getServletContext().getRealPath("/") + imageUrl;
            new File(oldImagePath).delete();
        }
        
        String uploadDir = request.getServletContext().getRealPath("/uploads");
        File uploadDirectory = new File(uploadDir);
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdir();
        }

        String fileName = UUID.randomUUID().toString() + getFileExtension(filePart.getSubmittedFileName());
        String filePath = uploadDir + File.separator + fileName;
        
        try {
            filePart.write(filePath);
            imageUrl = "uploads/" + fileName;
        } catch (Exception e) {
            System.out.println("Error al guardar el archivo: " + e.getMessage());
            e.printStackTrace();
        }
    }
    }
private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    
    // Obtener el producto antes de eliminarlo
    Product product = productDAO.getProductById(id);
    
    if (product != null && product.getImageUrl() != null && !product.getImageUrl().isEmpty()) {
        try {
            String imagePath = getServletContext().getRealPath("/" + product.getImageUrl());
            if (imagePath != null) {
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }
        } catch (Exception e) {
            // Log el error pero continúa con la eliminación del producto
            e.printStackTrace();
        }
    }
    
    // Eliminar el producto de la base de datos
    productDAO.deleteProduct(id);
    response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
}

    private String getFileExtension(String fileName) {
        if(fileName == null) return "";
        int lastDot = fileName.lastIndexOf('.');
        if(lastDot == -1) return "";
        return fileName.substring(lastDot);
    }
}