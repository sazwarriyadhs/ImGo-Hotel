package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	_ "github.com/lib/pq"
)

type Menu struct {
	ID       string  `json:"id"`
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	Category string  `json:"category"`
}

type Table struct {
	ID          string `json:"id"`
	TableNumber string `json:"table_number"`
	Capacity    int    `json:"capacity"`
	Status      string `json:"status"`
}

type Order struct {
	ID          string  `json:"id"`
	TableNumber string  `json:"table_number"`
	Status      string  `json:"status"`
	TotalPrice  float64 `json:"total_price"`
	ItemsCount  int     `json:"items_count"`
	CreatedAt   string  `json:"created_at"`
}

type Hotel struct {
	ID   string `json:"id"`
	Name string `json:"name"`
	City string `json:"city"`
}

var db *sql.DB

func initDB() {
	var err error
	
	// Connection string untuk PostgreSQL
	host := getEnv("DB_HOST", "postgres")
	port := getEnv("DB_PORT", "5432")
	user := getEnv("DB_USER", "postgres")
	password := getEnv("DB_PASSWORD", "newpassword123")
	dbname := getEnv("DB_NAME", "imgohotel")
	
	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	
	log.Printf("Connecting to database: %s:%s/%s", host, port, dbname)
	
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	err = db.Ping()
	if err != nil {
		log.Fatal("Failed to ping database:", err)
	}

	log.Println("✅ Connected to database successfully")
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func main() {
	// Initialize database
	initDB()
	defer db.Close()

	app := fiber.New()

	// Enable CORS for frontend
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "http://localhost:3000,http://localhost:3001,http://localhost:3002",
		AllowMethods:     "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization",
		AllowCredentials: true,
	}))

	// Health check
	app.Get("/", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"service": "restaurant-service",
			"status":  "running",
			"port":    8095,
		})
	})

	api := app.Group("/api/restaurant")

	// Get all hotels
	api.Get("/hotels", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, name, city 
			FROM hotels 
			ORDER BY city
		`)
		if err != nil {
			log.Println("Error fetching hotels:", err)
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch hotels",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var hotels []Hotel
		for rows.Next() {
			var hotel Hotel
			if err := rows.Scan(&hotel.ID, &hotel.Name, &hotel.City); err != nil {
				continue
			}
			hotels = append(hotels, hotel)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Hotels retrieved successfully",
			"data":    hotels,
		})
	})

	// Get menus by hotel
	api.Get("/menus", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel")
		
		if hotelCity == "" {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Hotel parameter is required",
			})
		}

		// Get menus
		rows, err := db.Query(`
			SELECT id, name, price, category 
			FROM menus 
			ORDER BY category, price
		`)
		if err != nil {
			log.Println("Error fetching menus:", err)
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch menus",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var menus []Menu
		for rows.Next() {
			var menu Menu
			if err := rows.Scan(&menu.ID, &menu.Name, &menu.Price, &menu.Category); err != nil {
				continue
			}
			menus = append(menus, menu)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Menus retrieved successfully",
			"hotel":   hotelCity,
			"total":   len(menus),
			"data":    menus,
		})
	})

	// Get tables by hotel
	api.Get("/tables", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel")
		
		if hotelCity == "" {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Hotel parameter is required",
			})
		}

		// Get hotel ID
		var hotelID string
		err := db.QueryRow("SELECT id FROM hotels WHERE city = $1", hotelCity).Scan(&hotelID)
		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Hotel not found",
			})
		}

		// Get tables
		rows, err := db.Query(`
			SELECT 
				rt.id, 
				rt.table_number, 
				rt.capacity,
				CASE 
					WHEN EXISTS (
						SELECT 1 FROM orders 
						WHERE table_id = rt.id 
						AND status IN ('pending', 'processing')
						AND DATE(created_at) = CURRENT_DATE
					) THEN 'occupied'
					ELSE 'available'
				END as status
			FROM restaurant_tables rt
			WHERE rt.hotel_id = $1
			ORDER BY rt.table_number
		`, hotelID)
		if err != nil {
			log.Println("Error fetching tables:", err)
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch tables",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var tables []Table
		for rows.Next() {
			var table Table
			if err := rows.Scan(&table.ID, &table.TableNumber, &table.Capacity, &table.Status); err != nil {
				continue
			}
			tables = append(tables, table)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Tables retrieved successfully",
			"hotel":   hotelCity,
			"total":   len(tables),
			"data":    tables,
		})
	})

	// Get orders by hotel
	api.Get("/orders", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel")
		status := c.Query("status", "active")
		
		if hotelCity == "" {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Hotel parameter is required",
			})
		}

		// Get hotel ID
		var hotelID string
		err := db.QueryRow("SELECT id FROM hotels WHERE city = $1", hotelCity).Scan(&hotelID)
		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Hotel not found",
			})
		}

		// Build query
		query := `
			SELECT 
				o.id,
				rt.table_number,
				o.status,
				COALESCE(o.total_price, 0) as total_price,
				COUNT(oi.id) as items_count,
				TO_CHAR(o.created_at, 'YYYY-MM-DD HH24:MI:SS') as created_at
			FROM orders o
			JOIN restaurant_tables rt ON rt.id = o.table_id
			LEFT JOIN order_items oi ON oi.order_id = o.id
			WHERE rt.hotel_id = $1
		`
		
		if status == "active" {
			query += " AND o.status IN ('pending', 'processing')"
		} else if status != "all" && status != "" {
			query += " AND o.status = $2"
		}
		
		query += " GROUP BY o.id, rt.table_number, o.status, o.total_price, o.created_at ORDER BY o.created_at DESC"
		
		var rows *sql.Rows
		if status != "active" && status != "all" && status != "" {
			rows, err = db.Query(query, hotelID, status)
		} else {
			rows, err = db.Query(query, hotelID)
		}
		
		if err != nil {
			log.Println("Error fetching orders:", err)
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch orders",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var orders []Order
		for rows.Next() {
			var order Order
			if err := rows.Scan(&order.ID, &order.TableNumber, &order.Status, &order.TotalPrice, &order.ItemsCount, &order.CreatedAt); err != nil {
				continue
			}
			orders = append(orders, order)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Orders retrieved successfully",
			"hotel":   hotelCity,
			"status":  status,
			"total":   len(orders),
			"data":    orders,
		})
	})

	log.Println("🚀 Restaurant service starting on port 8095")
	log.Println("📊 Endpoints:")
	log.Println("   GET  /api/restaurant/hotels")
	log.Println("   GET  /api/restaurant/menus?hotel={city}")
	log.Println("   GET  /api/restaurant/tables?hotel={city}")
	log.Println("   GET  /api/restaurant/orders?hotel={city}&status={active}")

	if err := app.Listen(":8095"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}