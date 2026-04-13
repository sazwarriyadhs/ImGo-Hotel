// C:\imgo-enterprise\backend\hotel-service\main.go
package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	_ "github.com/lib/pq"
)

type Hotel struct {
	ID          string  `json:"id"`
	Name        string  `json:"name"`
	Address     string  `json:"address"`
	City        string  `json:"city"`
	Rating      float64 `json:"rating"`
	Phone       string  `json:"phone"`
	Email       string  `json:"email"`
	Description string  `json:"description"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
	TotalRooms  int     `json:"total_rooms"`
	Photo       string  `json:"photo"`
}

// Menu struct untuk restaurant
type Menu struct {
	ID       string  `json:"id"`
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	Category string  `json:"category"`
	Photo    string  `json:"photo"`
}

var db *sql.DB

func main() {
	// Database connection - Ganti dengan kredensial Anda
	host := "localhost"
	port := "5432"
	user := "postgres"
	password := "newpassword123" // Ganti dengan password Anda
	dbname := "imgohotel"

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Failed to open database:", err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	log.Println("✓ Connected to PostgreSQL database!")
	log.Printf("  Database: %s, Host: %s:%s", dbname, host, port)

	app := fiber.New()

	// CORS
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowMethods: "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	// Health check
	app.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "ok",
			"service": "hotel-service",
			"db":      "connected",
		})
	})

	// ==================== HOTELS ENDPOINTS ====================
	
	// Get all hotels from database
	app.Get("/api/hotels", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT 
				id, 
				COALESCE(name, '') as name,
				COALESCE(address, '') as address,
				COALESCE(city, '') as city,
				COALESCE(rating, 0) as rating,
				COALESCE(phone, '') as phone,
				COALESCE(email, '') as email,
				COALESCE(description, '') as description,
				COALESCE(latitude, 0) as latitude,
				COALESCE(longitude, 0) as longitude,
				COALESCE(total_rooms, 0) as total_rooms,
				COALESCE(photo, '') as photo
			FROM hotels 
			ORDER BY name
		`)
		if err != nil {
			log.Println("Query error:", err)
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		var hotels []Hotel
		for rows.Next() {
			var h Hotel
			err := rows.Scan(
				&h.ID, &h.Name, &h.Address, &h.City,
				&h.Rating, &h.Phone, &h.Email, &h.Description,
				&h.Latitude, &h.Longitude, &h.TotalRooms, &h.Photo,
			)
			if err != nil {
				log.Println("Scan error:", err)
				continue
			}
			hotels = append(hotels, h)
		}

		log.Printf("✓ Returning %d hotels from database", len(hotels))
		return c.JSON(hotels)
	})

	// Get hotel by ID
	app.Get("/api/hotels/:id", func(c *fiber.Ctx) error {
		id := c.Params("id")
		var h Hotel

		queryErr := db.QueryRow(`
			SELECT 
				id, name, address, city, rating, phone, email, description,
				COALESCE(latitude, 0), COALESCE(longitude, 0),
				COALESCE(total_rooms, 0), COALESCE(photo, '')
			FROM hotels WHERE id = $1
		`, id).Scan(
			&h.ID, &h.Name, &h.Address, &h.City,
			&h.Rating, &h.Phone, &h.Email, &h.Description,
			&h.Latitude, &h.Longitude, &h.TotalRooms, &h.Photo,
		)

		if queryErr == sql.ErrNoRows {
			return c.Status(404).JSON(fiber.Map{"error": "Hotel not found"})
		}
		if queryErr != nil {
			return c.Status(500).JSON(fiber.Map{"error": queryErr.Error()})
		}
		return c.JSON(h)
	})

	// Get hotels by city
	app.Get("/api/hotels/city/:city", func(c *fiber.Ctx) error {
		city := "%" + c.Params("city") + "%"
		rows, err := db.Query(`
			SELECT id, name, address, city, rating, phone, email, description,
				COALESCE(latitude, 0), COALESCE(longitude, 0),
				COALESCE(total_rooms, 0), COALESCE(photo, '')
			FROM hotels WHERE city ILIKE $1 ORDER BY name
		`, city)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		var hotels []Hotel
		for rows.Next() {
			var h Hotel
			scanErr := rows.Scan(
				&h.ID, &h.Name, &h.Address, &h.City,
				&h.Rating, &h.Phone, &h.Email, &h.Description,
				&h.Latitude, &h.Longitude, &h.TotalRooms, &h.Photo,
			)
			if scanErr != nil {
				continue
			}
			hotels = append(hotels, h)
		}
		return c.JSON(hotels)
	})

	// Get unique cities with count
	app.Get("/api/hotels/cities", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT city, COUNT(*) as count 
			FROM hotels 
			WHERE city IS NOT NULL AND city != ''
			GROUP BY city 
			ORDER BY city
		`)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		type CityCount struct {
			City  string `json:"city"`
			Count int    `json:"count"`
		}
		var cities []CityCount
		for rows.Next() {
			var c CityCount
			if err := rows.Scan(&c.City, &c.Count); err != nil {
				continue
			}
			cities = append(cities, c)
		}
		return c.JSON(cities)
	})

	// ==================== RESTAURANT MENUS ENDPOINTS ====================
	
	// Get all menus
	app.Get("/api/menus", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, name, price, category, COALESCE(photo, '') as photo
			FROM menus 
			ORDER BY 
				CASE category
					WHEN 'Appetizer' THEN 1
					WHEN 'Main Course' THEN 2
					WHEN 'Vegetarian' THEN 3
					WHEN 'Dessert' THEN 4
					WHEN 'Drinks' THEN 5
					ELSE 6
				END,
				name
		`)
		if err != nil {
			log.Println("Query error:", err)
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		var menus []Menu
		for rows.Next() {
			var m Menu
			if err := rows.Scan(&m.ID, &m.Name, &m.Price, &m.Category, &m.Photo); err != nil {
				log.Println("Scan error:", err)
				continue
			}
			menus = append(menus, m)
		}

		log.Printf("✓ Returning %d menus from database", len(menus))
		return c.JSON(menus)
	})

	// Get menus by category
	app.Get("/api/menus/category/:category", func(c *fiber.Ctx) error {
		category := c.Params("category")
		rows, err := db.Query(`
			SELECT id, name, price, category, COALESCE(photo, '') as photo
			FROM menus 
			WHERE category = $1
			ORDER BY name
		`, category)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		var menus []Menu
		for rows.Next() {
			var m Menu
			if err := rows.Scan(&m.ID, &m.Name, &m.Price, &m.Category, &m.Photo); err != nil {
				continue
			}
			menus = append(menus, m)
		}
		return c.JSON(menus)
	})

	// Get menu by ID
	app.Get("/api/menus/:id", func(c *fiber.Ctx) error {
		id := c.Params("id")
		var m Menu

		queryErr := db.QueryRow(`
			SELECT id, name, price, category, COALESCE(photo, '') as photo
			FROM menus WHERE id = $1
		`, id).Scan(&m.ID, &m.Name, &m.Price, &m.Category, &m.Photo)

		if queryErr == sql.ErrNoRows {
			return c.Status(404).JSON(fiber.Map{"error": "Menu not found"})
		}
		if queryErr != nil {
			return c.Status(500).JSON(fiber.Map{"error": queryErr.Error()})
		}
		return c.JSON(m)
	})

	// Start server
	serverPort := ":8094"
	log.Println("========================================")
	log.Println("🚀 IMGO HOTEL SERVICE STARTED")
	log.Println("========================================")
	log.Printf("📡 Server: http://localhost%s", serverPort)
	log.Printf("❤️  Health: http://localhost%s/health", serverPort)
	log.Printf("🏨 Hotels: http://localhost%s/api/hotels", serverPort)
	log.Printf("🍽️  Menus: http://localhost%s/api/menus", serverPort)
	log.Println("========================================")

	if err := app.Listen(serverPort); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}