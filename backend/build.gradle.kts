plugins {
	java
	id("org.springframework.boot") version "3.4.1"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(21)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-security")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.hibernate:hibernate-spatial:6.3.0.Final")
	implementation("org.locationtech.jts:jts-core:1.19.0")
	implementation("org.mapstruct:mapstruct:1.6.3")
	implementation ("org.springframework.boot:spring-boot-starter-data-jpa")

	runtimeOnly ("org.postgresql:postgresql")

	annotationProcessor("org.mapstruct:mapstruct-processor:1.6.3")

	testRuntimeOnly("org.junit.platform:junit-platform-launcher")

	testImplementation("org.springframework.boot:spring-boot-starter-test")

	compileOnly ("org.projectlombok:lombok:1.18.36")
	annotationProcessor ("org.projectlombok:lombok:1.18.36")

	testCompileOnly ("org.projectlombok:lombok:1.18.36")
	testAnnotationProcessor ("org.projectlombok:lombok:1.18.36")
}

tasks.withType<Test> {
	useJUnitPlatform()
}


