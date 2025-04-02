#Stage 1:

#Build the application using java 21 and maven
FROM eclipse-temurin:21-jdk-jammy AS builder
#Set the work directory inside the container
WORKDIR /app
#Copy the Maven wrapper files
COPY .mvn/ .mvn
COPY mvnw .
#Grant execute permission to the Maven wrapper
RUN chmod +x ./mvnw
#Copy pom.xml, dependencies are only donwloaded when pom.xml file changes
COPY pom.xml .
#Download project dependencies. Use wrapper!
RUN ./mvnw dependency:go-offline -B
#Copy the rest of the source code
COPY src ./src
#Package the application with the Maven wrapper and skip the tests
RUN ./mvnw package -DskipTest

#Stage 2:

#Create the final runtime image using JRE 21
#Use a slim JRE image for a smaller footprint
FROM eclipse-temurin:21-jre-jammy
#Set the working directory inside the container
WORKDIR /app
#Create a non-root user for security reasons
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring
#Copy the executable jar file and rename it to app.jar for consistency
COPY --from=builder /app/target/*.jar app.jar
#Expose the port the app is running on
EXPOSE 8081
#Command to run the application when the container starts
ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]