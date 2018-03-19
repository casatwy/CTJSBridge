package main

import (
	"log"
	"net/http"
)

func main() {
	http.Handle("/", http.FileServer(http.Dir("./static")))
	log.Print("running at http://localhost")
	log.Fatal(http.ListenAndServe(":80", nil))
}
