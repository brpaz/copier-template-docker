.PHONY: lint build test help
.DEFAULT_GOAL := help

IMAGE_NAME:=myimage:dev

setup-env: # Setup local envrionment
	lefthook install

lint: ## Runs hadoint against application dockerfile
	@docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint:2.12.0-alpine Dockerfile

build: ## Builds the docker image
	@docker build . -t $(IMAGE_NAME)

test: build ## Runs a test in the image
	@docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/test zemanlx/container-structure-test:v1.14.0-alpine \
    test \
    --image $(IMAGE_NAME) \
    --config test/structure-tests.yaml

security-scan: build ## Check for vulnerabilities
	@docker run \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(PWD)/.cache:/tmp/trivy/ \
		--rm \
		aquasec/trivy:0.37.1 --cache-dir /tmp/trivy/ image $(IMAGE_NAME)

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

