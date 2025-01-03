<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.DashboardStats"%>
<%@ page import="dao.DashboardDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="model.OrderDTO"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    // Obtener usuario de la sesión
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/store/auth/login.jsp");
        return;
    }

    // Obtener estadísticas
    DashboardDAO dashboardDAO = new DashboardDAO();
    DashboardStats stats = dashboardDAO.getDashboardStats();
    List<OrderDTO> recentOrders = dashboardDAO.getRecentOrders();
    
    DecimalFormat currencyFormat = new DecimalFormat("$#,##0.00");
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
                         src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=0D8ABC&color=fff" 
                         alt="User photo">
                    <span class="hidden md:inline-block font-medium text-gray-700"><%= currentUser.getUsername() %></span>
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
                    <a href="#" class="sidebar-item flex items-center p-3 text-base font-normal rounded-lg bg-blue-50 text-blue-700">
                        <i class="fas fa-home w-6 h-6 transition duration-75"></i>
                        <span class="ml-3">Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/products.jsp" 
                       class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                        <i class="fas fa-box w-6 h-6 text-gray-500 transition duration-75"></i>
                        <span class="ml-3">Productos</span>
                        <span class="inline-flex justify-center items-center p-3 ml-3 w-3 h-3 text-sm font-medium text-blue-600 bg-blue-100 rounded-full"><%= stats.getTotalProducts() %></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                        <i class="fas fa-shopping-cart w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900"></i>
                        <span class="ml-3">Pedidos</span>
                        <span class="inline-flex justify-center items-center p-3 ml-3 w-3 h-3 text-sm font-medium text-blue-600 bg-blue-100 rounded-full"><%= stats.getTotalOrders() %></span>
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
                        <img class="w-10 h-10 rounded-full" src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=0D8ABC&color=fff" alt="Admin photo">
                        <div class="font-medium">
                            <div class="text-blue-600"><%= currentUser.getUsername() %></div>
                            <div class="text-sm text-blue-500"><%= currentUser.getEmail() %></div>
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
        <!-- Stats Grid -->
 <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2">    <!-- Card 1 - Total Ventas -->
    <div class="p-3 bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="flex items-center gap-2">
<div class="flex-1 min-w-0">                <p class="text-xs font-medium text-gray-600">Total Ventas</p>
                <p class="text-lg font-bold text-gray-900"><%= currencyFormat.format(stats.getTotalSales()) %></p>
            </div>
            <div class="p-2 bg-blue-50 rounded-full ml-auto">
                <i class="fas fa-dollar-sign text-blue-500 text-sm"></i>
            </div>
        </div>
    </div>

    <!-- Card 2 - Pedidos -->
    <div class="p-3 bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="flex items-center gap-2">
            <div>
                <p class="text-xs font-medium text-gray-600">Pedidos</p>
                <p class="text-lg font-bold text-gray-900"><%= stats.getTotalOrders() %></p>
            </div>
            <div class="p-2 bg-green-50 rounded-full ml-auto">
                <i class="fas fa-shopping-bag text-green-500 text-sm"></i>
            </div>
        </div>
    </div>

    <!-- Card 3 - Productos -->
    <div class="p-3 bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="flex items-center gap-2">
            <div>
                <p class="text-xs font-medium text-gray-600">Productos</p>
                <p class="text-lg font-bold text-gray-900"><%= stats.getTotalProducts() %></p>
            </div>
            <div class="p-2 bg-purple-50 rounded-full ml-auto">
                <i class="fas fa-box text-purple-500 text-sm"></i>
            </div>
        </div>
    </div>

    <!-- Card 4 - Usuarios -->
    <div class="p-3 bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="flex items-center gap-2">
            <div>
                <p class="text-xs font-medium text-gray-600">Usuarios</p>
                <p class="text-lg font-bold text-gray-900"><%= stats.getTotalUsers() %></p>
            </div>
            <div class="p-2 bg-yellow-50 rounded-full ml-auto">
                <i class="fas fa-users text-yellow-500 text-sm"></i>
            </div>
        </div>
    </div>
</div>


            <!-- Recent Orders Table -->
<div class="bg-white shadow-sm rounded-2xl border border-gray-200 max-w-full">
    <div class="p-6 border-b border-gray-200">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-semibold text-gray-900">Pedidos Recientes</h2>
            <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="text-blue-600 hover:text-blue-700 font-medium text-sm">Ver todos</a>
        </div>
    </div>
    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID Pedido</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cliente</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                <% for(OrderDTO order : recentOrders) { %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">#<%= order.getId() %></div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10">
                                    <img class="h-10 w-10 rounded-full" 
                                         src="https://ui-avatars.com/api/?name=<%= order.getUsername() %>" 
                                         alt="Cliente">
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900"><%= order.getUsername() %></div>
                                    <div class="text-sm text-gray-500"><%= order.getEmail() %></div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900 font-semibold">
                                <%= currencyFormat.format(order.getTotalAmount()) %>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full 
                                <%= order.getStatus().equals("COMPLETED") ? "bg-green-100 text-green-800" : 
                                    order.getStatus().equals("PENDING") ? "bg-yellow-100 text-yellow-800" :
                                    "bg-gray-100 text-gray-800" %>">
                                <%= order.getStatus() %>
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900"><%= dateFormat.format(order.getCreatedAt()) %></div>
                            <div class="text-sm text-gray-500"><%= timeFormat.format(order.getCreatedAt()) %></div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

        </main>
    </div>

    <script>
        // Toggle Sidebar
        document.getElementById('toggleSidebarMobile').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('hidden');
            document.getElementById('sidebarOverlay').classList.toggle('hidden');
        });

        // Close sidebar when clicking overlay
        document.getElementById('sidebarOverlay').addEventListener('click', function() {
            document.getElementById('sidebar').classList.add('hidden');
            this.classList.add('hidden');
        });
    </script>
</body>
</html>

                             