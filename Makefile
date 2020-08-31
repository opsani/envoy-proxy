IMAGE_NAME = "opsani/envoy-proxy:latest"

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: push
push: build
	docker push $(IMAGE_NAME)
