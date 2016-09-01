help:
	@echo '  init    prepare for build'
	@echo '  build   compile the source'
	@echo '  test    run unit tests'
	@echo '  fmt     check format'

circle-dep:
	docker info
	docker run --rm -e CGO_ENABLED=0 -e GOOS=linux -v "$PWD":"$PWD" -w "$PWD" golang:1.7 go build -a --installsuffix cgo -o up-and-up .
	docker build -t andrewh5u/up-and-up .

circle-test:
	docker run -d -p 8080:8080 andrewh5u/up-and-up https://www.google.com
	curl -v http://localhost:8080/up-and-up

circle-deploy:
	docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
	docker push andrewh5u/up-and-up

build: up-and-up

test:
	go test

fmt:
	gofmt -s -l *.go

clean:
	$(RM) up-and-up

up-and-up: main.go
	CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo -o $@ .
