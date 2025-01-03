package controller;

import config.DBConnection;
import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        try {
            switch (action) {
                case "/login":
                    login(request, response);
                    break;
                case "/register":
                    register(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp");
                    break;
            }
        } catch (SQLException ex) {
            // Log del error específico
            System.out.println("Error SQL: " + ex.getMessage());
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp?error=database");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.getUserByEmail(email);

            if (user != null && password.equals(user.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/store/index.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp?error=invalid");
            }
        } catch (SQLException e) {
            System.out.println("Error en login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp?error=database");
        }
    }

private void register(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException {
    // Primero probamos la conexión
    DBConnection.testConnection();
    
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm-password");

    System.out.println("Datos recibidos:");
    System.out.println("Username: " + username);
    System.out.println("Email: " + email);

    try {
        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            System.out.println("Las contraseñas no coinciden");
            response.sendRedirect(request.getContextPath() + "/store/auth/register.jsp?error=passwordMismatch");
            return;
        }

        // Crear nuevo usuario con rol USER
        User newUser = new User(username, password, email, "USER");
        System.out.println("Usuario creado, intentando insertar...");
        
        userDAO.insertUser(newUser);
        System.out.println("Usuario insertado exitosamente");

        // Redireccionar al login con mensaje de éxito
        response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp?registered=true");
        
    } catch (SQLException e) {
        System.out.println("Error SQL en registro: " + e.getMessage());
        System.out.println("SQL State: " + e.getSQLState());
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/store/auth/register.jsp?error=database");
    } catch (Exception e) {
        System.out.println("Error general: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/store/auth/register.jsp?error=database");
    }
}
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if ("/logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp");
        }
    }
}