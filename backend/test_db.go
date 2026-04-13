package main

import (
    "database/sql"
    "fmt"
    "log"
    _ "github.com/lib/pq"
)

func main() {
    // Connection string
    connStr := "host=localhost port=5432 user=postgres password=newpassword123 dbname=imgohotel sslmode=disable"
    
    // Connect to database
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        log.Fatal("Error opening database:", err)
    }
    defer db.Close()
    
    // Test connection
    err = db.Ping()
    if err != nil {
        log.Fatal("Cannot connect to database:", err)
    }
    
    fmt.Println("✅ Successfully connected to database: imgohotel")
    
    // List all tables
    rows, err := db.Query(`
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
        ORDER BY table_name
    `)
    if err != nil {
        log.Fatal("Error querying tables:", err)
    }
    defer rows.Close()
    
    fmt.Println("\n📋 Tables in database:")
    fmt.Println("=====================")
    count := 0
    for rows.Next() {
        var tableName string
        rows.Scan(&tableName)
        fmt.Printf("  - %s\n", tableName)
        count++
    }
    fmt.Printf("=====================\n")
    fmt.Printf("Total: %d tables\n", count)
}