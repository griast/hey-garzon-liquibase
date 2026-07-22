.PHONY: help run show-diagram clear-db

.DEFAULT_GOAL := help

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} \
		/^[a-zA-Z0-9_-]+:.*##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

run: ## Update the database
	./gradlew bootRun 

show-diagram: ## Show the database diagram
	open src/main/resources/db/model.html

clear-db: ## Clear the database
	./gradlew bootRun --args='--spring.liquibase.dropFirst=true --db.loadInitialData=true'

