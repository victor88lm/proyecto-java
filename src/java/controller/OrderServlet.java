package controller;

import dao.OrderDAO;
import model.Order;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            if (action != null) {
                switch (action) {
                    case "/updateStatus":
                        updateOrderStatus(request, response);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp");
                        break;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders.jsp");
            }
        } catch (SQLException ex) {
            System.out.println("Error en OrderServlet: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    String status = request.getParameter("status");
    
    System.out.println("ID recibido: " + id);
    System.out.println("Status recibido: " + status);
    
    try {
        boolean updated = orderDAO.updateOrderStatus(id, status);
        System.out.println("Actualización exitosa: " + updated);
        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp");
    } catch (SQLException e) {
        System.out.println("Error SQL: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}
    @Override
    public String getServletInfo() {
        return "OrderServlet handles order operations";
    }
}