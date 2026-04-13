package main

import (
    "log"

    "github.com/gofiber/fiber/v2"
    "github.com/gofiber/fiber/v2/middleware/cors"
)

type Employee struct {
    ID         string  `json:"id"`
    Name       string  `json:"name"`
    Email      string  `json:"email"`
    Phone      string  `json:"phone"`
    Position   string  `json:"position"`
    Department string  `json:"department"`
    HotelCity  string  `json:"hotelCity"`
    JoinDate   string  `json:"joinDate"`
    Status     string  `json:"status"`
    Salary     float64 `json:"salary"`
    Shift      string  `json:"shift"`
}

func main() {
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
            "service": "employee-service",
            "status":  "running",
            "port":    8100,
        })
    })

    api := app.Group("/api/employee")

    // Get all employees (mock data)
    api.Get("/employees", func(c *fiber.Ctx) error {
        mockEmployees := []Employee{
            {ID: "1", Name: "Manager Jakarta", Email: "jakarta.manager@imgo.com", Phone: "0812000001", Position: "General Manager", Department: "hotel", HotelCity: "Jakarta", JoinDate: "2024-01-15", Status: "active", Salary: 15000000, Shift: "morning"},
            {ID: "2", Name: "Front Desk Jakarta", Email: "jakarta.frontdesk@imgo.com", Phone: "0813000001", Position: "Front Desk Staff", Department: "hotel", HotelCity: "Jakarta", JoinDate: "2024-02-01", Status: "active", Salary: 5000000, Shift: "afternoon"},
            {ID: "3", Name: "Chef Jakarta", Email: "jakarta.chef@imgo.com", Phone: "0814000001", Position: "Chef", Department: "restaurant", HotelCity: "Jakarta", JoinDate: "2024-01-20", Status: "active", Salary: 7000000, Shift: "afternoon"},
            {ID: "4", Name: "Manager Surabaya", Email: "surabaya.manager@imgo.com", Phone: "0812000002", Position: "General Manager", Department: "hotel", HotelCity: "Surabaya", JoinDate: "2024-02-10", Status: "active", Salary: 14500000, Shift: "morning"},
            {ID: "5", Name: "Therapist Bali", Email: "bali.therapist@imgo.com", Phone: "0815000001", Position: "Spa Therapist", Department: "spa", HotelCity: "Bali", JoinDate: "2024-03-05", Status: "active", Salary: 8000000, Shift: "morning"},
            {ID: "6", Name: "Instructor Bandung", Email: "bandung.instructor@imgo.com", Phone: "0816000001", Position: "Pilates Instructor", Department: "pilates", HotelCity: "Bandung", JoinDate: "2024-01-25", Status: "active", Salary: 9000000, Shift: "morning"},
        }
        
        return c.JSON(fiber.Map{
            "success": true,
            "data":    mockEmployees,
            "total":   len(mockEmployees),
        })
    })

    // Get stats
    api.Get("/stats", func(c *fiber.Ctx) error {
        return c.JSON(fiber.Map{
            "success": true,
            "data": fiber.Map{
                "total_employees":     50,
                "active_employees":    48,
                "on_leave_employees":  2,
                "departments_count":   5,
            },
        })
    })

    // Get hotels list
    api.Get("/hotels", func(c *fiber.Ctx) error {
        hotels := []string{"Jakarta", "Surabaya", "Bandung", "Medan", "Semarang", "Makassar", "Denpasar", "Palembang", "Yogyakarta", "Malang", "Bali", "Lombok"}
        return c.JSON(fiber.Map{
            "success": true,
            "data":    hotels,
        })
    })

    // Get employees by department
    api.Get("/employees/department/:dept", func(c *fiber.Ctx) error {
        dept := c.Params("dept")
        mockEmployees := []Employee{
            {ID: "1", Name: "Manager Jakarta", Email: "jakarta.manager@imgo.com", Phone: "0812000001", Position: "General Manager", Department: dept, HotelCity: "Jakarta", JoinDate: "2024-01-15", Status: "active", Salary: 15000000, Shift: "morning"},
        }
        return c.JSON(fiber.Map{
            "success": true,
            "data":    mockEmployees,
        })
    })

    // Get employees by hotel
    api.Get("/employees/hotel/:city", func(c *fiber.Ctx) error {
        city := c.Params("city")
        mockEmployees := []Employee{
            {ID: "1", Name: "Manager " + city, Email: city + ".manager@imgo.com", Phone: "0812000001", Position: "General Manager", Department: "hotel", HotelCity: city, JoinDate: "2024-01-15", Status: "active", Salary: 15000000, Shift: "morning"},
        }
        return c.JSON(fiber.Map{
            "success": true,
            "data":    mockEmployees,
        })
    })

    log.Println("Employee service starting on port 8100")
    log.Println("Endpoints:")
    log.Println("   GET  /api/employee/employees")
    log.Println("   GET  /api/employee/employees/department/:dept")
    log.Println("   GET  /api/employee/employees/hotel/:city")
    log.Println("   GET  /api/employee/hotels")
    log.Println("   GET  /api/employee/stats")

    if err := app.Listen(":8100"); err != nil {
        log.Fatal("Failed to start server:", err)
    }
}
