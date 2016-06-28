package main

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

func TestUp(t *testing.T) {
	const want = "UP"
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { fmt.Fprintln(w, "ok") }))
	defer ts.Close()
	w := httptest.NewRecorder()
	var urls []string
	urls = append(urls, ts.URL)
	urls = append(urls, ts.URL)
	handlerUrlArgs(w, nil, urls, time.Duration(2*time.Second), false)
	got := w.Body.String()
	if got != want {
		t.Fatal("want:", want, "got:", got)
	}
}
