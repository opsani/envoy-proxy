VERSION ?= "latest"
IMAGE_NAME ?= "opsani/envoy-proxy:${VERSION}"

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: run
run: build
	docker run -it --rm $(IMAGE_NAME)

.PHONY: push
push: build
	docker push $(IMAGE_NAME)
