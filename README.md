# Welcome to WeSki App

WeSki is a mobile platform built to improve the winter sports experience through connectivity, safety, statistics, and social interaction.

## Requirements:
Make sure you have:
- An Android emulator configured **or**
- An Android device in **developer mode**

### Backend
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Java 21](https://www.oracle.com/ro/java/technologies/downloads/)
- [Gradle 8.11.1](https://docs.gradle.org/8.11.1/release-notes.html)

### Frontend
- [Flutter 3.29.0](https://flutter.dev/)
- [Dart 3.7.0](https://dart.dev/)
- JDK 21

### Database
> **Note:** This setup is not mandatory. It is required only if the server is not running and testing is performed locally.  
> The `.sql` file should be imported into the Docker container, and PostGIS must be installed.

- [Docker](https://www.docker.com/) installed
- [PostgreSQL 42.7.4](https://www.postgresql.org/) installed + PostGIS

## Steps to start the application:

### Step1
- clone the repository

### Step2 - Backend
- Open the backend directory in IntelliJ **or** other editor
- Make sure PostgreSQL is running (if testing locally).
- Update `application.properties` with your DB credentials (if needed).
- Run the main class: `WeskiApplication`.

**OR** using terminal

- if testing locally make sure docker container is running
- navigate using `cd` command to "backend" directory
- compile the project using `./gradlew build`
- run application `gradlew.bat bootRun`

### Step3 - Frontend
- Open the frontend directory in IntelliJ **or** other editor
- Open pubspec.yaml and click `Pub get` to get all dependinces
- Run the main class `main.dart`

**OR** using terminal

- navigate using `cd` command to "frontend" directory
- get all dependinces `flutter pub get`
- run the app `flutter run` for a better preformance `flutter --release`

>**Optional:** To build the apk `flutter build apk --release` and will be located in `build/app/outputs/flutter-apk/app-release.apk`

### Step4 - Only if testing locally

- Make a docker container using: `docker run --name postgres-postgis-container \ -e POSTGRES_USER=admin \ -e POSTGRES_PASSWORD=admin123 \ -e POSTGRES_DB=weski_db \ -p 5432:5432 \ -d postgis/postgis:15-3.3`
- How to copy .sql file in container `docker cp path/to/file.sql postgres-postgis-container:/file.sql`
- Connect to container and import: `docker exec -it postgres-postgis-container bash` then `psql -U admin -d weski_db -f /file.sql`
- How to run container `docker run --name postgres-postgis-container \ -e POSTGRES_USER=admin \ -e POSTGRES_PASSWORD=admin123 \-e POSTGRES_DB=weski_db \ -p 5432:5432 \ -d postgis/postgis`
- Verify is running `docker ps`





