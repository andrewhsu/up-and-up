FROM scratch
MAINTAINER Andrew Hsu <xuzuan@gmail.com>
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY up-and-up /up-and-up
EXPOSE 8080
ENTRYPOINT ["/up-and-up"]
