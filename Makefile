.DEFAULT_GOAL := help

ifeq (, $(shell which docker))
	$(error "docker is not installed, installation instructions in https://docs.docker.com/engine/installation/")
endif

define is_number
	$(shell test '$(1)' -eq '$(1)' 2>/dev/null && echo 1 || echo '')
endef

platform=$(shell uname -s)
ifeq ($(platform),Darwin)
	docker_command = @docker compose
else
	docker_command = @docker-compose
endif

command := $(firstword $(MAKECMDGOALS))
arguments := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
list_arguments := $(foreach arg, $(arguments),\
	$(if $(strip $(call is_number, $(arg))), $(arg), -$(arg))\
)

help:
	@echo "To use arguments pass them normally without the dash(-)" charecter
	@echo Example: "\n " for: rubocop -a "\n " use: rubocop a "\n"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

rubocop:## run rubocop
	@bundle e rubocop $(list_arguments)

dependencies.start.dev:## Start needed containers for this application in development environment.
	${docker_command} -f docker-compose.dependencies.yml --project-name prosas_challenge up prosas_challenge_development_db -d --remove-orphans

dependencies.start.test:## Start needed containers for this application in test environment.
	${docker_command} -f docker-compose.dependencies.yml --project-name prosas_challenge up prosas_challenge_test_db -d --remove-orphans

dependencies.stop:## Stop needed containers for this application.
	${docker_command} -f docker-compose.dependencies.yml --project-name prosas_challenge stop

remove.dev.container:## Remove database dev container
	@docker rm prosas_challenge_development_db

remove.test.container:## Remove database test container
	@docker rm prosas_challenge_test_db

clean.dev.volume:## clean database volume for dev.
	@docker volume rm prosas_challenge_db_volume

clean.test.volume:## clean database volume for test.
	@docker volume rm prosas_challenge_db_test_volume

%:
	@true