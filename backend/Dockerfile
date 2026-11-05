FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

RUN groupadd --system app && useradd --system --gid app app

COPY target/*.jar /app/app.jar

USER app

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
