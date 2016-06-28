package main

import (
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"
)

func printUsage() {
	fmt.Fprintf(os.Stderr, "Usage: %s [flags] URL ...\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "\nWhere flags are:\n")
	flag.PrintDefaults()
}

func checkUrl(u string, d time.Duration, s bool, c chan bool) {
	tr := &http.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: s}}
	cli := &http.Client{Timeout: d, Transport: tr}
	resp, err := cli.Get(u)
	if err != nil {
		log.Print(err)
		c <- false
		return
	}
	if resp.StatusCode != 200 {
		log.Println(u, resp.StatusCode)
		c <- false
		return
	}
	c <- true
}

func handlerUrlArgs(w http.ResponseWriter, req *http.Request, urls []string, d time.Duration, s bool) {
	c := make(chan bool)
	for _, url := range urls {
		go checkUrl(url, d, s, c)
	}
	for i := 0; i < len(urls); i++ {
		r, ok := <-c
		if !ok {
			log.Fatal("unexpected closing of channel")
		}
		if !r {
			http.Error(w, "DOWN", http.StatusBadGateway)
			return
		}
	}

	if _, err := fmt.Fprintf(w, "UP"); err != nil {
		log.Fatal(err)
	}
}

func makeHandler(f func(http.ResponseWriter, *http.Request, []string, time.Duration, bool), urls []string, d time.Duration, s bool) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) { f(w, req, urls, d, s) }
}

func main() {
	flag.Usage = printUsage
	path := flag.String("path", "/up-and-up", "path to serve from")
	port := flag.Uint("port", 8080, "port to listen on")
	skipverify := flag.Bool("skipverify", false, "skip tls cert check")
	timeout := flag.Duration("timeout", time.Duration(2*time.Second), "connect to origin timeout")
	flag.Parse()

	if flag.NArg() < 1 {
		printUsage()
		os.Exit(1)
	}

	var urls []string

	for i := 0; i < flag.NArg(); i++ {
		u, err := url.Parse(flag.Arg(i))
		if err != nil {
			log.Fatal(err)
		}
		urls = append(urls, u.String())
	}

	log.Println("path", *path)
	log.Println("port", *port)
	log.Println("timeout", *timeout)
	log.Println("urls", urls)
	http.HandleFunc(*path, makeHandler(handlerUrlArgs, urls, *timeout, *skipverify))
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", *port), nil))
}
