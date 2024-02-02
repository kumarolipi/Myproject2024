FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM nginx:alpine
WORKDIR /app
COPY --from=build /app/target/my-webapp-1.0.4.war /usr/share/nginx/html
