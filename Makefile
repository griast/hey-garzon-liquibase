show-diagram:
	open src/main/resources/db/model.html

clear-database:
	./gradlew bootRun --args='--spring.liquibase.dropFirst=true --db.loadInitialData=true'