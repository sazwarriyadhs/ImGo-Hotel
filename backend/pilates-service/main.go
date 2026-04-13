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

type PilatesClass struct {
	ID                string `json:"id"`
	Name              string `json:"name"`
	Capacity          int    `json:"capacity"`
	Schedule          string `json:"schedule"`
	InstructorName    string `json:"instructor_name"`
	InstructorSpecialty string `json:"instructor_specialty"`
}

type Instructor struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Specialty string `json:"specialty"`
}

type Hotel struct {
	ID   string `json:"id"`
	Name string `json:"name"`
	City string `json:"city"`
}

var db *sql.DB

func initDB() {
	var err error
	
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

	// Enable CORS
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "http://localhost:3000,http://localhost:3001,http://localhost:3002",
		AllowMethods:     "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization",
		AllowCredentials: true,
	}))

	// Health check
	app.Get("/", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"service": "pilates-service",
			"status":  "running",
			"port":    8097,
		})
	})

	api := app.Group("/api/pilates")

	// Get all hotels
	api.Get("/hotels", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, name, city 
			FROM hotels 
			ORDER BY city
		`)
		if err != nil {
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

	// Get all instructors
	api.Get("/instructors", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, name, specialty 
			FROM instructors 
			ORDER BY name
		`)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch instructors",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var instructors []Instructor
		for rows.Next() {
			var instructor Instructor
			if err := rows.Scan(&instructor.ID, &instructor.Name, &instructor.Specialty); err != nil {
				continue
			}
			instructors = append(instructors, instructor)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Instructors retrieved successfully",
			"data":    instructors,
		})
	})

	// Get pilates classes by hotel
	api.Get("/classes", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel")
		
		if hotelCity == "" {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Hotel parameter is required",
			})
		}

		rows, err := db.Query(`
			SELECT 
				pc.id,
				pc.name,
				pc.capacity,
				pc.schedule,
				i.name as instructor_name,
				i.specialty as instructor_specialty
			FROM pilates_classes pc
			JOIN instructors i ON i.id = pc.instructor_id
			JOIN hotels h ON h.id = pc.hotel_id
			WHERE h.city = $1
			ORDER BY pc.schedule
		`, hotelCity)
		
		if err != nil {
			log.Println("Error fetching classes:", err)
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch classes",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var classes []PilatesClass
		for rows.Next() {
			var class PilatesClass
			if err := rows.Scan(&class.ID, &class.Name, &class.Capacity, &class.Schedule, &class.InstructorName, &class.InstructorSpecialty); err != nil {
				continue
			}
			classes = append(classes, class)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Classes retrieved successfully",
			"hotel":   hotelCity,
			"total":   len(classes),
			"data":    classes,
		})
	})

	// Get pilates class by ID
	api.Get("/classes/:id", func(c *fiber.Ctx) error {
		classID := c.Params("id")
		
		var class PilatesClass
		err := db.QueryRow(`
			SELECT 
				pc.id,
				pc.name,
				pc.capacity,
				pc.schedule,
				i.name as instructor_name,
				i.specialty as instructor_specialty
			FROM pilates_classes pc
			JOIN instructors i ON i.id = pc.instructor_id
			WHERE pc.id = $1
		`, classID).Scan(&class.ID, &class.Name, &class.Capacity, &class.Schedule, &class.InstructorName, &class.InstructorSpecialty)
		
		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Class not found",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    class,
		})
	})

	// Get bookings for a class
	api.Get("/classes/:id/bookings", func(c *fiber.Ctx) error {
		classID := c.Params("id")
		
		rows, err := db.Query(`
			SELECT 
				pb.id,
				u.name as user_name,
				u.email,
				pb.status,
				pb.created_at
			FROM pilates_bookings pb
			JOIN users u ON u.id = pb.user_id
			WHERE pb.class_id = $1
			ORDER BY pb.created_at DESC
		`, classID)
		
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch bookings",
			})
		}
		defer rows.Close()

		var bookings []fiber.Map
		for rows.Next() {
			var id, userName, email, status, createdAt string
			rows.Scan(&id, &userName, &email, &status, &createdAt)
			bookings = append(bookings, fiber.Map{
				"id":         id,
				"user_name":  userName,
				"email":      email,
				"status":     status,
				"created_at": createdAt,
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    bookings,
		})
	})

	log.Println("🚀 Pilates service starting on port 8097")
	log.Println("📊 Endpoints:")
	log.Println("   GET  /api/pilates/hotels")
	log.Println("   GET  /api/pilates/instructors")
	log.Println("   GET  /api/pilates/classes?hotel={city}")
	log.Println("   GET  /api/pilates/classes/:id")
	log.Println("   GET  /api/pilates/classes/:id/bookings")

	if err := app.Listen(":8097"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}