# Usa una imagen base con Java y Apache Ant preinstalados
FROM openjdk:17-jdk-slim

# Instalar Apache Ant
RUN apt-get update && apt-get install -y ant

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos del repositorio al contenedor
COPY . .

# Ejecuta el comando de construcción con Ant
RUN ant jar

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "dist/mi-aplicacion.jar"]
