FROM openjdk:23-ea-17-jdk-bullseye
WORKDIR /app
ARG BUILD_VERSION
ENV APP_VERSION=${BUILD_VERSION}
COPY myapp/target/myapp-${BUILD_VERSION}.jar /app/myapp-${BUILD_VERSION}.jar
CMD ["java", "-jar", "myapp-${APP_VERSION}.jar"]