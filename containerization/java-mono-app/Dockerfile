# Budowanie
FROM amazoncorretto:17-alpine-jdk AS builder

WORKDIR /app

# Kopiowanie plików konfiguracyjnych
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Kompilacja aplikacji
RUN chmod +x gradlew
RUN ./gradlew bootJar -x test --no-daemon

# Środowisko uruchomieniowe
FROM amazoncorretto:17-alpine AS runtime

WORKDIR /app

# Instalacja zależności do generowania raportów (fonty)
RUN apk update && apk add --no-cache \
    fontconfig \
    libretls \
    freetype \
    ttf-dejavu

ENV JAVA_AWT_HEADLESS=true

# Kopiowanie artefaktu
COPY --from=builder /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
