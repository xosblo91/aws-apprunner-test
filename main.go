package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	// Handle the /hello-world endpoint
	http.HandleFunc("/hello-world", func(w http.ResponseWriter, r *http.Request) {
		// Extract Basic Auth credentials
		username, password, ok := r.BasicAuth()

		// Check for credentials and validate
		if !ok || username != "testuser" || password != "testpass" {
			// If invalid, ask client for credentials again
			w.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// If credentials are valid, respond with Hello, World!
		fmt.Fprintln(w, "Hello, World!")
	})

	// Start the server on port 8080
	log.Println("Server listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
