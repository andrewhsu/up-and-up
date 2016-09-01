help:
	@echo '  init    prepare for build'
	@echo '  build   compile the source'
	@echo '  test    run unit tests'
	@echo '  fmt     check format'

circle-dep:
	docker info
	docker run --rm -v "$(CURDIR)":"$(CURDIR)" -w "$(CURDIR)" golang:1.7 gofmt -s -l *.go
	docker run --rm -v "$(CURDIR)":"$(CURDIR)" -w "$(CURDIR)" golang:1.7 go test -v -cover
	docker run --rm -e CGO_ENABLED=0 -e GOOS=linux -v "$(CURDIR)":"$(CURDIR)" -w "$(CURDIR)" golang:1.7 go build -a --installsuffix cgo -o up-and-up .
	docker build -t andrewh5u/up-and-up .

circle-test:
	docker run -d -p 8080:8080 andrewh5u/up-and-up http://circleci.com
	sleep 2 && curl -s -S -f -v http://localhost:8080/up-and-up > /dev/null

circle-deploy:
	@docker login -e $(DOCKER_EMAIL) -u $(DOCKER_USER) -p $(DOCKER_PASS)
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
