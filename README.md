# up-and-up

This micro web service checks if a web service is up and returning
HTTP response 200. This can be used to serve a "status" web service
checked by a load balancer that is separate from the actual web
service that serves production traffic. In this way, you can
gracefully drain existing connections behind the load balancer by
taking down the "status" web service.

Can also check multiple web services in parallel and fail quick on
the first non-200 response.

Example setup:

```
bash$ up-and-up -path /status -port 5000 -timeout 1s https://www.yahoo.com/ https://www.google.com/
```

Example response:

```
bash$ curl -v http://localhost:5000/status
*   Trying ::1...
* Connected to localhost (::1) port 5000 (#0)
> GET /status HTTP/1.1
> Host: localhost:5000
> User-Agent: curl/7.47.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Tue, 28 Jun 2016 07:35:48 GMT
< Content-Length: 2
< Content-Type: text/plain; charset=utf-8
<
* Connection #0 to host localhost left intact
UP
```
