<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Order"%>
<%@ page import="dao.OrderDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>

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
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getAllOrders();
    DecimalFormat currencyFormat = new DecimalFormat("$#,##0.00");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy HH:mm");

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
                           class="sidebar-item flex items-center p-3 text-base font-normal text-gray-900 rounded-lg hover:bg-gray-100">
                            <i class="fas fa-box w-6 h-6 text-gray-500 transition duration-75"></i>
                            <span class="ml-3">Productos</span>
                            <span class="inline-flex justify-center items-center p-3 ml-3 w-3 h-3 text-sm font-medium text-blue-600 bg-blue-100 rounded-full"><%= stats.getTotalProducts()%></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="sidebar-item flex items-center p-3 text-base font-normal rounded-lg bg-blue-50 text-blue-700">
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

                <div class="p-4">
                    <!-- Filtros y búsqueda -->
                    <div class="bg-white rounded-lg shadow-sm p-4 mb-4">
                        <div class="flex flex-wrap items-center gap-3">
                            <select id="filterStatus" class="rounded-lg border-gray-300 text-sm focus:ring-blue-500 focus:border-blue-500">
                                <option value="">Todos los estados</option>
                                <option value="PENDING">Pendiente</option>
                                <option value="PROCESSING">En Proceso</option>
                                <option value="COMPLETED">Completado</option>
                                <option value="CANCELLED">Cancelado</option>
                            </select>

                            <input id="filterDate" type="date" class="rounded-lg border-gray-300 text-sm focus:ring-blue-500 focus:border-blue-500">

                            <div class="relative">
                                <input id="filterSearch" type="text" placeholder="Buscar pedido..." 
                                       class="pl-8 rounded-lg border-gray-300 text-sm focus:ring-blue-500 focus:border-blue-500">
                                <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                            </div>
                            
                                    <button onclick="clearFilters()" 
                class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 text-sm font-medium rounded-md">
            Limpiar Filtros
        </button>
                        </div>

                    </div>

                    <!-- Tabla de pedidos -->
                    <div class="bg-white rounded-lg shadow-sm">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">Cliente</th>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">Total</th>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">Estado</th>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">Fecha</th>
                                        <th scope="col" class="p-4 text-left text-xs font-medium text-gray-500 uppercase">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200 bg-white">
                                    <% for (Order order : orders) {%>
                                    <tr class="hover:bg-gray-50">
                                        <td class="p-4 text-sm text-gray-900">#<%= order.getId()%></td>
                                        <td class="p-4">
                                            <div class="flex items-center gap-3">
                                                <img class="w-8 h-8 rounded-full" 
                                                     src="https://ui-avatars.com/api/?name=<%= order.getUsername()%>" 
                                                     alt="<%= order.getUsername()%>">
                                                <div>
                                                    <div class="text-sm font-medium text-gray-900"><%= order.getUsername()%></div>
                                                    <div class="text-sm text-gray-500"><%= order.getEmail()%></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="p-4 text-sm font-medium text-gray-900">
                                            <%= currencyFormat.format(order.getTotalAmount())%>
                                        </td>
                                        <td class="p-4">
                                            <span class="px-2 py-1 text-xs font-medium rounded-full
                                                  <%= order.getStatus().equals("COMPLETED") ? "bg-green-100 text-green-800"
                                                          : order.getStatus().equals("PROCESSING") ? "bg-blue-100 text-blue-800"
                                                          : order.getStatus().equals("CANCELLED") ? "bg-red-100 text-red-800"
                                                          : "bg-yellow-100 text-yellow-800"%>">
                                                <%= order.getStatus()%>
                                            </span>
                                        </td>
                                        <td class="p-4 text-sm text-gray-500">
                                            <%= dateFormat.format(order.getCreatedAt())%>
                                        </td>
                                        <td class="p-4">
                                            <div class="flex items-center gap-2">
                                                <button onclick="showOrderDetails(<%= order.getId()%>)" 
                                                        class="text-blue-600 hover:text-blue-900">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button onclick="showStatusModal(<%= order.getId()%>)" 
                                                        class="text-green-600 hover:text-green-900">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Modal para cambiar estado -->
                <div id="statusModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
                    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
                        <div class="mt-3">
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Actualizar Estado del Pedido</h3>
                            <select id="newStatus" class="w-full rounded-lg border-gray-300 mb-4">
                                <option value="PENDING">Pendiente</option>
                                <option value="PROCESSING">En Proceso</option>
                                <option value="COMPLETED">Completado</option>
                                <option value="CANCELLED">Cancelado</option>
                            </select>
                            <div class="flex justify-end gap-3">
                                <button onclick="closeStatusModal()" 
                                        class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 text-sm font-medium rounded-md">
                                    Cancelar
                                </button>
                                <button onclick="updateOrderStatus()" 
                                        class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md">
                                    Actualizar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>

<script>
    let currentOrderId = null;

    function showOrderDetails(orderId) {
        window.location.href = '${pageContext.request.contextPath}/admin/order-details.jsp?id=' + orderId;
    }

    function showStatusModal(orderId) {
        currentOrderId = orderId;
        document.getElementById('statusModal').classList.remove('hidden');
    }

    function closeStatusModal() {
        document.getElementById('statusModal').classList.add('hidden');
        currentOrderId = null;
    }

    function updateOrderStatus() {
        if (!currentOrderId) return;
        const newStatus = document.getElementById('newStatus').value;
        window.location.href = '${pageContext.request.contextPath}/order/updateStatus?id=' + currentOrderId + '&status=' + newStatus;
    }

    document.getElementById('toggleSidebarMobile').addEventListener('click', function () {
        document.getElementById('sidebar').classList.toggle('hidden');
        document.getElementById('sidebarOverlay').classList.toggle('hidden');
    });

    document.getElementById('sidebarOverlay').addEventListener('click', function () {
        document.getElementById('sidebar').classList.add('hidden');
        this.classList.add('hidden');
    });

    document.addEventListener("DOMContentLoaded", () => {
        const filterStatus = document.getElementById("filterStatus");
        const filterDate = document.getElementById("filterDate");
        const filterSearch = document.getElementById("filterSearch");
        const tableRows = document.querySelectorAll("tbody tr");

        function parseDate(dateString) {
            const parts = dateString.match(/(\d{2})\s(\w{3})\s(\d{4})\s(\d{2}):(\d{2})/);
            if (!parts) return null;
            const [_, day, month, year, hour, minute] = parts;
            const months = {
                ene: 0, feb: 1, mar: 2, abr: 3, may: 4, jun: 5,
                jul: 6, ago: 7, sep: 8, oct: 9, nov: 10, dic: 11,
            };
            return new Date(year, months[month.toLowerCase()], day, hour, minute);
        }

        function applyFilters() {
            const filterStatus = document.getElementById('filterStatus').value.toLowerCase();
            const filterDate = document.getElementById('filterDate').value ? new Date(document.getElementById('filterDate').value).setHours(0, 0, 0, 0) : null;
            const filterSearch = document.getElementById('filterSearch').value.toLowerCase();

            const tableRows = document.querySelectorAll("tbody tr");

            tableRows.forEach(row => {
                const status = row.querySelector("td:nth-child(4) span")?.textContent.toLowerCase();
                const dateText = row.querySelector("td:nth-child(5)")?.textContent.trim();
                const date = dateText ? parseDate(dateText) : null;
                const searchText = row.textContent.toLowerCase();

                const matchStatus = !filterStatus || status.includes(filterStatus);
                const matchDate = !filterDate || (date && date.setHours(0, 0, 0, 0) === filterDate);
                const matchSearch = !filterSearch || searchText.includes(filterSearch);

                row.style.display = matchStatus && matchDate && matchSearch ? 'table-row' : 'none';
            });
        }

        filterStatus.addEventListener("change", applyFilters);
        filterDate.addEventListener("input", applyFilters);
        filterSearch.addEventListener("input", applyFilters);
    });

    function clearFilters() {
        document.getElementById('filterStatus').value = '';
        document.getElementById('filterDate').value = '';
        document.getElementById('filterSearch').value = '';

        const tableRows = document.querySelectorAll("tbody tr");
        tableRows.forEach(row => row.style.display = 'table-row');
    }
</script>
