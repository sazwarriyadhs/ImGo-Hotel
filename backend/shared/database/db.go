package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func Connect() (*sql.DB, error) {
	// Get environment variables with defaults
	host := getEnv("DB_HOST", "localhost")
	port := getEnv("DB_PORT", "5432")
	user := getEnv("DB_USER", "postgres")
	password := getEnv("DB_PASSWORD", "newpassword123")
	dbname := getEnv("DB_NAME", "imgohotel")

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname,
	)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, fmt.Errorf("error opening database: %v", err)
	}

	// Set connection pool
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)
	db.SetConnMaxLifetime(5 * time.Minute)

	// Test connection
	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("error connecting to database: %v", err)
	}

	log.Println("✅ Database connected successfully")
	return db, nil
}

func InitDB() error {
	var err error
	DB, err = Connect()
	if err != nil {
		return err
	}
	return nil
}

func CloseDB() {
	if DB != nil {
		DB.Close()
		log.Println("Database connection closed")
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// Health check function
func HealthCheck() error {
	if DB == nil {
		return fmt.Errorf("database not initialized")
	}
	return DB.Ping()
}

// Generic query helpers
func QueryRow(query string, args ...interface{}) *sql.Row {
	return DB.QueryRow(query, args...)
}

func Query(query string, args ...interface{}) (*sql.Rows, error) {
	return DB.Query(query, args...)
}

func Exec(query string, args ...interface{}) (sql.Result, error) {
	return DB.Exec(query, args...)
}

// Transaction helpers
func BeginTx() (*sql.Tx, error) {
	return DB.Begin()
}

// Get table count
func GetTableCount(tableName string) (int, error) {
	var count int
	query := fmt.Sprintf("SELECT COUNT(*) FROM %s", tableName)
	err := DB.QueryRow(query).Scan(&count)
	return count, err
}

// Check if record exists
func RecordExists(tableName, columnName, value string) (bool, error) {
	var exists bool
	query := fmt.Sprintf("SELECT EXISTS(SELECT 1 FROM %s WHERE %s = $1)", tableName, columnName)
	err := DB.QueryRow(query, value).Scan(&exists)
	return exists, err
}