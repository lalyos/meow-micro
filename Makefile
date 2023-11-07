LOCAL_CLIENT_IMAGE = meow-client:1.0
LOCAL_SERVER_IMAGE = meow-server:1.0
CLIENT_IMAGE = ttl.sh/meow-client:1.0
SERVER_IMAGE = ttl.sh/meow-server:1.0
HELM_DEPLOY = meow-micro
SECRET_NAME = grpc-secret

.PHONY: clean
clean:
	docker rmi -f $(CLIENT_IMAGE)
	docker rmi -f $(SERVER_IMAGE)
	helm delete $(HELM_DEPLOY)

.PHONY: build
build:
	docker build --platform=linux/amd64 -t $(CLIENT_IMAGE) -f client/Dockerfile .
	docker build --platform=linux/amd64 -t $(SERVER_IMAGE) -f server/Dockerfile .
	docker build -t $(LOCAL_CLIENT_IMAGE) -f client/Dockerfile .
	docker build -t $(LOCAL_SERVER_IMAGE) -f server/Dockerfile .

push:
	docker push $(CLIENT_IMAGE)
	docker push $(SERVER_IMAGE)

.PHONY: install
install:
	helm repo add meow   git+https://github.com/diazjf/meow-micro@/helm?ref=main
	helm upgrade -i meow-micro meow/meow-micro --values https://raw.githubusercontent.com/diazjf/meow-micro/main/helm/Values.yaml --set server.image=$(SERVER_IMAGE) --set client.image=$(CLIENT_IMAGE)
