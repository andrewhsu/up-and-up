help:
	@echo '  init    prepare for build'
	@echo '  build   compile the source'
	@echo '  test    run unit tests'
	@echo '  fmt     check format'

init:

build: up-and-up

test:
	go test

fmt:
	gofmt -s -l *.go

clean:
	$(RM) up-and-up

up-and-up: main.go
	CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo -o $@ .
