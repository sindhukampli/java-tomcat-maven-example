# Stage 1: Build the application with Maven
FROM maven:amazoncorretto as builder

WORKDIR /app

# Copy the application source code to the container
COPY . .

# Build the application
RUN mvn clean install

# Stage 2: Set up NGINX and copy the built application
FROM nginx:alpine

# Copy the built application to NGINX's web directory
COPY --from=builder /app/target/*.war /usr/share/nginx/html/

# Expose port 80 to allow traffic to the NGINX server
EXPOSE 80
