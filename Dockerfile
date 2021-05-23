FROM golang:alpine as builder
WORKDIR /go/src/github.com/andrewhsu/up-and-up/
COPY main.go go.mod ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -v -o up-and-up .

FROM alpine:latest as certs
RUN apk --no-cache add ca-certificates

FROM scratch as final
COPY --from=builder /go/src/github.com/andrewhsu/up-and-up/up-and-up /up-and-up
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
EXPOSE 8080
ENTRYPOINT ["/up-and-up"]
