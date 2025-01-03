<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Tienda Online</title>
    <% if (request.getParameter("error") != null) { %>
    <div class="mb-4 p-4 rounded-lg 
        <% if (request.getParameter("error").equals("invalid")) { %>
            bg-red-100 text-red-700 border-red-400
        <% } else if (request.getParameter("error").equals("database")) { %>
            bg-red-100 text-red-700 border-red-400
        <% } %>">
        <% if (request.getParameter("error").equals("invalid")) { %>
            Email o contraseña incorrectos
        <% } else if (request.getParameter("error").equals("database")) { %>
            Error en el servidor. Por favor intente más tarde
        <% } %>
    </div>
<% } %>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gradient-to-r from-blue-100 to-blue-200 h-full m-0 overflow-hidden">

    <div class="h-screen flex items-center justify-center p-4">
        <div class="max-w-md w-full space-y-8">
            <!-- Card con efecto de cristal -->
            <div class="bg-white bg-opacity-80 backdrop-blur-lg rounded-xl shadow-2xl p-8 space-y-6">
                <div class="text-center">
                    <!-- Icono de registro estilizado -->
                    <div class="mx-auto h-16 w-16 bg-blue-600 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-user-plus text-3xl text-white"></i>
                    </div>
                    <h2 class="text-3xl font-bold text-gray-900 tracking-tight">
                        Crear cuenta
                    </h2>
                    <p class="mt-2 text-sm text-gray-600">
                        ¿Ya tienes cuenta?
                        <a href="${pageContext.request.contextPath}/store/auth/login.jsp" 
                           class="font-medium text-blue-600 hover:text-blue-500 transition-colors duration-200">
                            Inicia sesión
                        </a>
                    </p>
                </div>

                <form class="mt-8 space-y-6" action="${pageContext.request.contextPath}/auth/register" method="POST">
                    <div class="space-y-4">
                        <div class="relative">
                            <label for="username" class="block text-sm font-medium text-gray-700 mb-1">
                                Nombre de usuario
                            </label>
                            <div class="relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-user text-gray-400"></i>
                                </div>
                                <input id="username" name="username" type="text" required 
                                       class="pl-10 block w-full border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white bg-opacity-90 p-2.5" 
                                       placeholder="Usuario">
                            </div>
                        </div>

                        <div class="relative">
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                                Correo electrónico
                            </label>
                            <div class="relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-envelope text-gray-400"></i>
                                </div>
                                <input id="email" name="email" type="email" required 
                                       class="pl-10 block w-full border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white bg-opacity-90 p-2.5" 
                                       placeholder="ejemplo@correo.com">
                            </div>
                        </div>

                        <div class="relative">
                            <label for="password" class="block text-sm font-medium text-gray-700 mb-1">
                                Contraseña
                            </label>
                            <div class="relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-lock text-gray-400"></i>
                                </div>
                                <input id="password" name="password" type="password" required 
                                       class="pl-10 block w-full border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white bg-opacity-90 p-2.5" 
                                       placeholder="••••••••">
                            </div>
                        </div>

                        <div class="relative">
                            <label for="confirm-password" class="block text-sm font-medium text-gray-700 mb-1">
                                Confirmar contraseña
                            </label>
                            <div class="relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-lock text-gray-400"></i>
                                </div>
                                <input id="confirm-password" name="confirm-password" type="password" required 
                                       class="pl-10 block w-full border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white bg-opacity-90 p-2.5" 
                                       placeholder="••••••••">
                            </div>
                        </div>
                    </div>

                    <div class="flex items-center">
                        <input id="terms" name="terms" type="checkbox" required
                               class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                        <label for="terms" class="ml-2 block text-sm text-gray-700">
                            Acepto los términos y condiciones
                        </label>
                    </div>

                    <div>
                        <button type="submit" 
                                class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-200">
                            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                                <i class="fas fa-user-plus text-blue-500 group-hover:text-blue-400"></i>
                            </span>
                            Registrarse
                        </button>
                    </div>
                </form>
            </div>

            <!-- Decorative circles -->
            <div class="hidden sm:block absolute top-0 right-0 -mt-12 -mr-12 h-32 w-32 rounded-full bg-blue-200 opacity-50"></div>
            <div class="hidden sm:block absolute bottom-0 left-0 -mb-12 -ml-12 h-32 w-32 rounded-full bg-blue-300 opacity-50"></div>
        </div>
    </div>
</body>
</html>