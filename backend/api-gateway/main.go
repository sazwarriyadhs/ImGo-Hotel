package main

import (
    "log"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Write([]byte(`{"service":"api-gateway","status":"running"}`))
    })
    
    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Write([]byte(`{"status":"ok","service":"api-gateway"}`))
    })
    
    log.Println("API Gateway running on http://localhost:8092")
    log.Fatal(http.ListenAndServe(":8092", nil))
}
