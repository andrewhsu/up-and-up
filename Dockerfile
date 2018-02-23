FROM golang:alpine as builder
WORKDIR /go/src/github.com/andrewhsu/up-and-up/
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo -o up-and-up .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/andrewhsu/up-and-up/up-and-up /up-and-up
EXPOSE 8080
ENTRYPOINT ["/up-and-up"]
