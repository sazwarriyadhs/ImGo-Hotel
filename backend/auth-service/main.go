package main

import (
    "log"
    "net/http"
)

func main() {
    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Write([]byte(`{"status":"ok","service":"auth-service"}`))
    })
    
    http.HandleFunc("/login", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Write([]byte(`{"success":true,"user":{"name":"Sarah Wilson","email":"sarah.wilson@example.com"}}`))
    })
    
    log.Println("Auth service running on http://localhost:8093")
    log.Fatal(http.ListenAndServe(":8093", nil))
}
