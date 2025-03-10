.PHONY: lint test docs schema changelog test-% test-ns test-crds-consistency

# Docker images for testing and documentation generation
IMAGE_CHART_TESTING=quay.io/helmpack/chart-testing:v3.12.0
IMAGE_HELM_CHANGELOG=ghcr.io/traefik/helm-changelog:v0.3.0
IMAGE_HELM_DOCS=jnorwood/helm-docs:v1.14.2
IMAGE_HELM_UNITTEST=docker.io/helmunittest/helm-unittest:3.17.0-0.7.2

# Create snapshot directories for tests
customer-support/tests/__snapshot__:
	@mkdir -p customer-support/tests/__snapshot__
	@mkdir -p customer-support-crds/tests/__snapshot__

# Run Helm Unittest
test: customer-support/tests/__snapshot__
	docker run ${DOCKER_ARGS} --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts $(IMAGE_HELM_UNITTEST) /charts/hack/test.sh

# Run namespace validation test
test-ns:
	./hack/check-ns.sh

# Check CRD consistency
test-crds-consistency:
	./hack/check-crds-consistency.sh

# Lint Helm Charts using chart-testing
lint:
	docker run ${DOCKER_ARGS} --env GIT_SAFE_DIR="true" --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts $(IMAGE_CHART_TESTING) /charts/hack/ct.sh lint

# Generate Helm documentation
docs:
	docker run --rm -v "$(CURDIR):/helm-docs" $(IMAGE_HELM_DOCS) -o VALUES.md

# Run custom Helm tests based on the provided argument
test-%:
	docker run ${DOCKER_ARGS} --network=host --env GIT_SAFE_DIR="true" --entrypoint /bin/sh --rm -v $(CURDIR):/charts -v $(HOME)/.kube:/root/.kube -w /charts $(IMAGE_CHART_TESTING) /charts/hack/ct.sh $*

# Generate JSON schema for Helm values
# Requires helm-values-schema-json plugin
# Install it via:
# $ helm plugin install https://github.com/losisin/helm-values-schema-json.git
schema:
	cd customer-support && helm schema
	cd customer-support-crds && helm schema

# Update Helm Changelog
changelog:
	@echo "== Updating Changelogs..."
	@docker run -it --rm -v $(CURDIR):/data $(IMAGE_HELM_CHANGELOG)
	@./hack/changelog.sh
	@echo "== Changelog update completed."
