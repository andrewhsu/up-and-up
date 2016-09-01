FROM scratch
MAINTAINER Andrew Hsu <xuzuan@gmail.com>
COPY up-and-up /up-and-up
EXPOSE 8080
ENTRYPOINT ["/up-and-up"]
