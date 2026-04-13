package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	_ "github.com/lib/pq"
)

type Promotion struct {
	ID           string    `json:"id"`
	Title        string    `json:"title"`
	Description  string    `json:"description"`
	Type         string    `json:"type"`
	DiscountType string    `json:"discount_type"`
	DiscountValue float64  `json:"discount_value"`
	StartDate    time.Time `json:"start_date"`
	EndDate      time.Time `json:"end_date"`
	ApplicableTo []string  `json:"applicable_to"`
	Status       string    `json:"status"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Reward struct {
	ID            string  `json:"id"`
	Name          string  `json:"name"`
	PointsRequired int    `json:"points_required"`
	Description   string  `json:"description"`
	ImageURL      string  `json:"image_url"`
	Stock         int     `json:"stock"`
	HotelID       string  `json:"hotel_id"`
	HotelName     string  `json:"hotel_name"`
	Status        string  `json:"status"`
	CreatedAt     time.Time `json:"created_at"`
}

type Broadcast struct {
	ID           string    `json:"id"`
	Title        string    `json:"title"`
	Message      string    `json:"message"`
	Type         string    `json:"type"`
	TargetHotels []string  `json:"target_hotels"`
	SentBy       string    `json:"sent_by"`
	SentAt       time.Time `json:"sent_at"`
	Status       string    `json:"status"`
}

type LoyaltyPoints struct {
	UserID       string `json:"user_id"`
	UserName     string `json:"user_name"`
	Points       int    `json:"points"`
	TotalEarned  int    `json:"total_earned"`
	TotalRedeemed int   `json:"total_redeemed"`
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
			"service": "promo-service",
			"status":  "running",
			"port":    8098,
		})
	})

	api := app.Group("/api/promo")

	// ==================== PROMOTIONS ====================
	
	// Get all promotions
	api.Get("/promotions", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, title, description, type, discount_type, discount_value, 
			       start_date, end_date, applicable_to, status, created_at, updated_at
			FROM promotions
			ORDER BY created_at DESC
		`)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch promotions",
				"error":   err.Error(),
			})
		}
		defer rows.Close()

		var promotions []Promotion
		for rows.Next() {
			var p Promotion
			var applicableTo string
			err := rows.Scan(&p.ID, &p.Title, &p.Description, &p.Type, &p.DiscountType, 
				&p.DiscountValue, &p.StartDate, &p.EndDate, &applicableTo, 
				&p.Status, &p.CreatedAt, &p.UpdatedAt)
			if err != nil {
				continue
			}
			// Parse applicable_to from string to array
			if applicableTo != "" {
				// Simple parsing, in production use proper JSON
				if applicableTo == "all" {
					p.ApplicableTo = []string{"all"}
				}
			}
			promotions = append(promotions, p)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Promotions retrieved successfully",
			"data":    promotions,
		})
	})

	// Get active promotions
	api.Get("/promotions/active", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel", "")
		
		query := `
			SELECT id, title, description, type, discount_type, discount_value, 
			       start_date, end_date, applicable_to, status, created_at, updated_at
			FROM promotions
			WHERE status = 'active' 
			AND CURRENT_DATE BETWEEN start_date AND end_date
		`
		
		if hotelCity != "" {
			query += fmt.Sprintf(` AND (applicable_to = 'all' OR applicable_to LIKE '%%%s%%')`, hotelCity)
		}
		
		query += " ORDER BY discount_value DESC"
		
		rows, err := db.Query(query)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch active promotions",
			})
		}
		defer rows.Close()

		var promotions []Promotion
		for rows.Next() {
			var p Promotion
			var applicableTo string
			rows.Scan(&p.ID, &p.Title, &p.Description, &p.Type, &p.DiscountType,
				&p.DiscountValue, &p.StartDate, &p.EndDate, &applicableTo,
				&p.Status, &p.CreatedAt, &p.UpdatedAt)
			promotions = append(promotions, p)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    promotions,
		})
	})

	// Get promotion by ID
	api.Get("/promotions/:id", func(c *fiber.Ctx) error {
		id := c.Params("id")
		var p Promotion
		var applicableTo string

		err := db.QueryRow(`
			SELECT id, title, description, type, discount_type, discount_value, 
			       start_date, end_date, applicable_to, status, created_at, updated_at
			FROM promotions WHERE id = $1
		`, id).Scan(&p.ID, &p.Title, &p.Description, &p.Type, &p.DiscountType,
			&p.DiscountValue, &p.StartDate, &p.EndDate, &applicableTo,
			&p.Status, &p.CreatedAt, &p.UpdatedAt)

		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Promotion not found",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    p,
		})
	})

	// Create promotion
	api.Post("/promotions", func(c *fiber.Ctx) error {
		var p Promotion
		if err := c.BodyParser(&p); err != nil {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Invalid request body",
			})
		}

		applicableTo := "all"
		if len(p.ApplicableTo) > 0 && p.ApplicableTo[0] != "all" {
			applicableTo = fmt.Sprintf("%v", p.ApplicableTo)
		}

		_, err := db.Exec(`
			INSERT INTO promotions (id, title, description, type, discount_type, discount_value, 
			                        start_date, end_date, applicable_to, status, created_at, updated_at)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, NOW(), NOW())
		`, generateUUID(), p.Title, p.Description, p.Type, p.DiscountType,
			p.DiscountValue, p.StartDate, p.EndDate, applicableTo, "active")

		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to create promotion",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Promotion created successfully",
		})
	})

	// ==================== REWARDS ====================

	// Get all rewards
	api.Get("/rewards", func(c *fiber.Ctx) error {
		hotelCity := c.Query("hotel", "")
		
		query := `
			SELECT r.id, r.name, r.points_required, r.description, r.image_url, r.stock, 
			       r.status, r.created_at, h.id as hotel_id, h.name as hotel_name
			FROM rewards r
			JOIN hotels h ON h.id = r.hotel_id
			WHERE r.status = 'active'
		`
		
		if hotelCity != "" {
			query += fmt.Sprintf(" AND h.city = '%s'", hotelCity)
		}
		
		query += " ORDER BY r.points_required"
		
		rows, err := db.Query(query)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch rewards",
			})
		}
		defer rows.Close()

		var rewards []Reward
		for rows.Next() {
			var r Reward
			rows.Scan(&r.ID, &r.Name, &r.PointsRequired, &r.Description, &r.ImageURL,
				&r.Stock, &r.Status, &r.CreatedAt, &r.HotelID, &r.HotelName)
			rewards = append(rewards, r)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    rewards,
		})
	})

	// Get reward by ID
	api.Get("/rewards/:id", func(c *fiber.Ctx) error {
		id := c.Params("id")
		var r Reward

		err := db.QueryRow(`
			SELECT r.id, r.name, r.points_required, r.description, r.image_url, r.stock, 
			       r.status, r.created_at, h.id as hotel_id, h.name as hotel_name
			FROM rewards r
			JOIN hotels h ON h.id = r.hotel_id
			WHERE r.id = $1
		`, id).Scan(&r.ID, &r.Name, &r.PointsRequired, &r.Description, &r.ImageURL,
			&r.Stock, &r.Status, &r.CreatedAt, &r.HotelID, &r.HotelName)

		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Reward not found",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    r,
		})
	})

	// ==================== LOYALTY POINTS ====================

	// Get user loyalty points
	api.Get("/loyalty/:userId", func(c *fiber.Ctx) error {
		userId := c.Params("userId")
		
		var lp LoyaltyPoints
		err := db.QueryRow(`
			SELECT lp.user_id, u.name, lp.points, lp.total_earned, lp.total_redeemed
			FROM loyalty_points lp
			JOIN users u ON u.id = lp.user_id
			WHERE lp.user_id = $1
		`, userId).Scan(&lp.UserID, &lp.UserName, &lp.Points, &lp.TotalEarned, &lp.TotalRedeemed)

		if err != nil {
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "User not found",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    lp,
		})
	})

	// Redeem reward
	api.Post("/redeem", func(c *fiber.Ctx) error {
		var req struct {
			UserID   string `json:"user_id"`
			RewardID string `json:"reward_id"`
		}
		
		if err := c.BodyParser(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Invalid request body",
			})
		}

		// Start transaction
		tx, err := db.Begin()
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to start transaction",
			})
		}

		// Get user points
		var userPoints int
		err = tx.QueryRow("SELECT points FROM loyalty_points WHERE user_id = $1", req.UserID).Scan(&userPoints)
		if err != nil {
			tx.Rollback()
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "User not found",
			})
		}

		// Get reward info
		var rewardPoints, rewardStock int
		var rewardName string
		err = tx.QueryRow("SELECT points_required, stock, name FROM rewards WHERE id = $1", req.RewardID).Scan(&rewardPoints, &rewardStock, &rewardName)
		if err != nil {
			tx.Rollback()
			return c.Status(404).JSON(fiber.Map{
				"success": false,
				"message": "Reward not found",
			})
		}

		// Check eligibility
		if userPoints < rewardPoints {
			tx.Rollback()
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Insufficient points",
				"user_points": userPoints,
				"points_required": rewardPoints,
			})
		}

		if rewardStock <= 0 {
			tx.Rollback()
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Reward out of stock",
			})
		}

		// Deduct points
		_, err = tx.Exec(`
			UPDATE loyalty_points 
			SET points = points - $1, total_redeemed = total_redeemed + $1
			WHERE user_id = $2
		`, rewardPoints, req.UserID)
		if err != nil {
			tx.Rollback()
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to update points",
			})
		}

		// Update stock
		_, err = tx.Exec("UPDATE rewards SET stock = stock - 1 WHERE id = $1", req.RewardID)
		if err != nil {
			tx.Rollback()
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to update stock",
			})
		}

		// Insert transaction record
		_, err = tx.Exec(`
			INSERT INTO point_transactions (user_id, points, type, reference_id, description)
			VALUES ($1, $2, 'redeem', $3, $4)
		`, req.UserID, rewardPoints, req.RewardID, fmt.Sprintf("Redeemed: %s", rewardName))
		if err != nil {
			tx.Rollback()
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to record transaction",
			})
		}

		// Commit transaction
		if err := tx.Commit(); err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to commit transaction",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Reward redeemed successfully",
			"points_deducted": rewardPoints,
		})
	})

	// ==================== STATISTICS ====================

	// Get dashboard stats
	api.Get("/stats", func(c *fiber.Ctx) error {
		var activePromos, availableRewards, totalHotels, totalPoints int

		// Active promotions
		db.QueryRow(`
			SELECT COUNT(*) FROM promotions 
			WHERE status = 'active' AND CURRENT_DATE BETWEEN start_date AND end_date
		`).Scan(&activePromos)

		// Available rewards
		db.QueryRow(`
			SELECT COUNT(*) FROM rewards WHERE status = 'active' AND stock > 0
		`).Scan(&availableRewards)

		// Total hotels
		db.QueryRow("SELECT COUNT(*) FROM hotels").Scan(&totalHotels)

		// Total points distributed
		db.QueryRow("SELECT COALESCE(SUM(total_earned), 0) FROM loyalty_points").Scan(&totalPoints)

		return c.JSON(fiber.Map{
			"success": true,
			"data": fiber.Map{
				"active_promos":     activePromos,
				"available_rewards": availableRewards,
				"total_hotels":      totalHotels,
				"total_points":      totalPoints,
			},
		})
	})

	// ==================== BROADCAST ====================

	// Send broadcast
	api.Post("/broadcast", func(c *fiber.Ctx) error {
		var b Broadcast
		if err := c.BodyParser(&b); err != nil {
			return c.Status(400).JSON(fiber.Map{
				"success": false,
				"message": "Invalid request body",
			})
		}

		_, err := db.Exec(`
			INSERT INTO broadcast_messages (id, title, message, type, target_hotels, sent_by, sent_at, status)
			VALUES ($1, $2, $3, $4, $5, $6, NOW(), 'sent')
		`, generateUUID(), b.Title, b.Message, b.Type, b.TargetHotels, b.SentBy)

		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to send broadcast",
			})
		}

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Broadcast sent successfully",
		})
	})

	// Get broadcast history
	api.Get("/broadcasts", func(c *fiber.Ctx) error {
		rows, err := db.Query(`
			SELECT id, title, message, type, target_hotels, sent_at, status
			FROM broadcast_messages
			ORDER BY sent_at DESC
			LIMIT 50
		`)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"success": false,
				"message": "Failed to fetch broadcasts",
			})
		}
		defer rows.Close()

		var broadcasts []Broadcast
		for rows.Next() {
			var b Broadcast
			var targetHotels string
			rows.Scan(&b.ID, &b.Title, &b.Message, &b.Type, &targetHotels, &b.SentAt, &b.Status)
			broadcasts = append(broadcasts, b)
		}

		return c.JSON(fiber.Map{
			"success": true,
			"data":    broadcasts,
		})
	})

	log.Println("🚀 Promo service starting on port 8098")
	log.Println("📊 Endpoints:")
	log.Println("   GET  /api/promo/promotions")
	log.Println("   GET  /api/promo/promotions/active")
	log.Println("   GET  /api/promo/rewards")
	log.Println("   GET  /api/promo/loyalty/:userId")
	log.Println("   POST /api/promo/redeem")
	log.Println("   GET  /api/promo/stats")
	log.Println("   POST /api/promo/broadcast")

	if err := app.Listen(":8098"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}

func generateUUID() string {
	return fmt.Sprintf("%d", time.Now().UnixNano())
}