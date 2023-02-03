.PHONY: help test deps lint
.DEFAULT_GOAL := help

lint: ## Lint Copier configuration file
	docker run --rm -it -v $(PWD):/data -w /data cytopia/yamllint:alpine-1 copier.yml

test: ## Test task
	rm -rf dist
	copier -f \
		-d 'project_name=Test' \
		-d 'project_description=Description' \
		-d 'repo_slug=acme/teste' \
		-d 'docker_registry=dockerhub' \
		./ dist/

deps: ## Install dependencies
	pip install -r requirements.txt

help: ## Show help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
