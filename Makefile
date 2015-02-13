.PHONY: docker-consul

docker-consul:
	docker build -t $@ .
