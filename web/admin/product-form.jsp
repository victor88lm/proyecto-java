<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product"%>
<%@ page import="dao.ProductDAO"%>

<%@ page import="model.Product"%>
<%@ page import="dao.ProductDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="model.User"%>
<%@ page import="model.DashboardStats"%>
<%@ page import="dao.DashboardDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="model.OrderDTO"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    ProductDAO productDAO = new ProductDAO();
    Product product = null;
    String action = "insert";

    if (request.getParameter("id") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        product = productDAO.getProductById(id);
        action = "update";
    }

    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp");
        return;
    }

    // Obtener estadísticas
    DashboardDAO dashboardDAO = new DashboardDAO();
    DashboardStats stats = dashboardDAO.getDashboardStats();
    List<OrderDTO> recentOrders = dashboardDAO.getRecentOrders();

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .sidebar-item {
                transition: all 0.3s ease;
            }
            .sidebar-item:hover {
                transform: translateX(8px);
            }
        </style>
    </head>
    <body class="bg-gray-50">
        <!-- Top Navigation -->
        <nav class="bg-white border-b border-gray-200 fixed z-30 w-full">
            <div class="px-3 py-3 lg:px-5 lg:pl-3">
                <div class="flex items-center justify-between">
                    <div class="flex items-center justify-start">
                        <button id="toggleSidebarMobile" aria-expanded="true" aria-controls="sidebar" class="lg:hidden mr-2 text-gray-600 hover:text-gray-900 cursor-pointer p-2 hover:bg-gray-100 focus:bg-gray-100 focus:ring-2 focus:ring-gray-100 rounded">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"></path>
                            </svg>
                        </button>
                        <div class="text-xl font-bold flex items-center lg:ml-2.5">
                            <span class="self-center whitespace-nowrap text-blue-600">Dashboard Admin</span>
                        </div>
                    </div>
                    <div class="flex items-center">
                        <div class="flex items-center space-x-6">
                            <div class="relative">
                                <button class="text-gray-500 hover:text-gray-900 p-2 rounded-full hover:bg-gray-100">
                                    <i class="fas fa-bell text-xl"></i>
                                    <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-red-100 transform translate-x-1/2 -translate-y-1/2 bg-red-600 rounded-full">2</span>
                                </button>
                            </div>
                            <div class="flex items-center gap-2">
                                <img class="w-8 h-8 rounded-full" 
                                     src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername()%>&background=0D8ABC&color=fff" 
                                     alt="User photo">
                                <span class="hidden md:inline-block font-medium text-gray-700"><%= currentUser.getUsername()%></span>
                            </div>
                            <a href="${pageContext.request.contextPath}/auth/logout" 
                               class="text-red-600 hover:text-red-700 font-medium flex items-center gap-2 hover:bg-red-50 px-3 py-2 rounded-lg transition-colors duration-200">
                                <i class="fas fa-sign-out-alt"></i>
                                <span class="hidden md:inline">Cerrar Sesión</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Sidebar -->
        <aside id="sidebar" class="fixed hidden z-20 h-full top-0 left-0 pt-16 lg:flex flex-shrink-0 flex-col w-64 bg-white transform lg:transform-none transition-transform duration-300" aria-label="Sidebar">
            <div class="relative flex-1 flex flex-col min-h-0 border-r border-gray-200 bg-white">
                <div class="flex-1 flex flex-col pt-5 pb-4 overflow-y-auto">
                    <div class="flex-1 px-3 space-y-1">
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                            <i class="fas fa-home w-6 h-6 transition duration-75"></i>
                            <span class="ml-3">Dashboard</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/products.jsp" 
                           class="sidebar-item flex items-center p-3 text-base font-normal rounded-lg bg-blue-50 text-blue-700">
                            <i class="fas fa-box w-6 h-6 text-gray-500 transition duration-75"></i>
                            <span class="ml-3">Productos</span>
                            <span class="inline-flex justify-center items-center p-3 ml-3 w-3 h-3 text-sm font-medium text-blue-600 bg-blue-100 rounded-full"><%= stats.getTotalProducts()%></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                            <i class="fas fa-shopping-cart w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900"></i>
                            <span class="ml-3">Pedidos</span>
                            <span class="inline-flex justify-center items-center p-3 ml-3 w-3 h-3 text-sm font-medium text-blue-600 bg-blue-100 rounded-full"><%= stats.getTotalOrders()%></span>
                        </a>
                        <a href="#" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                            <i class="fas fa-users w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900"></i>
                            <span class="ml-3">Usuarios</span>
                        </a>
                        <div class="space-y-2 pt-2">
                            <div class="text-gray-400 uppercase text-xs font-semibold px-3">Configuración</div>
                            <a href="#" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                                <i class="fas fa-cog w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900"></i>
                                <span class="ml-3">Ajustes</span>
                            </a>
                            <a href="#" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                                <i class="fas fa-store w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900"></i>
                                <span class="ml-3">Tienda</span>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="hidden absolute bottom-0 left-0 justify-center p-4 space-x-4 w-full lg:flex bg-white border-r border-gray-200">
                    <div class="pt-4 pb-2 px-3 bg-blue-50 rounded-lg w-full">
                        <div class="flex items-center space-x-4">
                            <img class="w-10 h-10 rounded-full" src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="Admin photo">
                            <div class="font-medium">
                                <div class="text-blue-600">Admin User</div>
                                <div class="text-sm text-blue-500">admin@example.com</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Mobile Sidebar Overlay -->
        <div class="bg-gray-900 opacity-50 hidden fixed inset-0 z-10" id="sidebarOverlay"></div>

        <!-- Main Content -->
        <div id="main-content" class="h-full w-auto bg-gray-50 relative overflow-y-auto lg:ml-64 pt-16">
            <main class="p-2">
                <div class="max-w-2xl mx-auto bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-xl font-bold mb-6"><%= product == null ? "Nuevo Producto" : "Editar Producto"%></h2>

                    <form action="${pageContext.request.contextPath}/product/<%= action%>" 
                          method="POST" 
                          enctype="multipart/form-data" 
                          class="space-y-4">
                        <% if (product != null) {%>
                        <input type="hidden" name="id" value="<%= product.getId()%>">
                        <% }%>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Nombre</label>
                            <input type="text" name="name" required 
                                   value="<%= product != null ? product.getName() : ""%>"
                                   class="w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
                            <textarea name="description" rows="3" 
                                      class="w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500"><%= product != null ? product.getDescription() : ""%></textarea>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Precio</label>
                                <div class="relative">
                                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">$</span>
                                    <input type="number" name="price" step="0.01" required
                                           value="<%= product != null ? product.getPrice() : ""%>"
                                           class="w-full pl-7 rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500">
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
                                <input type="number" name="stock" required
                                       value="<%= product != null ? product.getStock() : ""%>"
                                       class="w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Imagen</label>
                            <input type="file" name="image" accept="image/*"
                                   class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                            <% if (product != null && product.getImageUrl() != null) {%>
                            <div class="mt-2">
                                <img src="${pageContext.request.contextPath}/<%= product.getImageUrl()%>" 
                                     class="h-20 w-20 object-cover rounded">
                            </div>
                            <% }%>
                        </div>

                        <div class="flex justify-end space-x-3 pt-4">
                            <button type="button" onclick="history.back()" 
                                    class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                                Cancelar
                            </button>
                            <button type="submit" 
                                    class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                <%= product == null ? "Crear Producto" : "Actualizar Producto"%>
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>


        <script>
            // Toggle Sidebar
            document.getElementById('toggleSidebarMobile').addEventListener('click', function () {
                document.getElementById('sidebar').classList.toggle('hidden');
                document.getElementById('sidebarOverlay').classList.toggle('hidden');
            });

            // Close sidebar when clicking overlay
            document.getElementById('sidebarOverlay').addEventListener('click', function () {
                document.getElementById('sidebar').classList.add('hidden');
                this.classList.add('hidden');
            });
        </script>
