# Budowanie (pełne JDK do skompilowania aplikacji)
FROM amazoncorretto:17-alpine-jdk AS builder

WORKDIR /app

# Kopiowanie plików wrappera i definicji zależności (Optymalizacja cache'u warstw)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Nadanie uprawnień
RUN chmod +x gradlew

# Kopiowanie kodu źródłowego i budowanie artefaktu (bootJar z pominięciem testów)
COPY src src
RUN ./gradlew clean bootJar -x test

# JRE
FROM amazoncorretto:17-alpine AS runtime

WORKDIR /app

# Profil produkcyjny
ENV SPRING_PROFILES_ACTIVE=prod

# Kopiowanie jar'a 
COPY --from=builder /app/build/libs/*.jar app.jar

# Uruchomienie aplikacji
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
