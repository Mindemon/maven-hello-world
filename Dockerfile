FROM openjdk:23-ea-17-jdk-bullseye
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
WORKDIR /app
ARG BUILD_VERSION
ENV APP_VERSION=${BUILD_VERSION}
COPY myapp/target/myapp-${BUILD_VERSION}.jar /app/myapp-${BUILD_VERSION}.jar
RUN chown -R appuser:appgroup /app
USER appuser
ENTRYPOINT ["sh", "-c", "java -jar myapp-${APP_VERSION}.jar"]