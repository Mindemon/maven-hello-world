FROM openjdk:23-ea-17-jdk-bullseye
WORKDIR /app
ARG VERSION
ENV APP_VERSION=${VERSION}
COPY myapp/target/myapp-${VERSION}.jar /app/myapp-${VERSION}.jar
CMD ["java", "-jar", "myapp-${APP_VERSION}.jar"]