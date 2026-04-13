package main

import (
    "github.com/gofiber/fiber/v2"
)

func main() {
    app := fiber.New()

    app.Get("/", func(c *fiber.Ctx) error {
        return c.JSON(fiber.Map{
            "service": "ai-service",
            "status": "running",
        })
    })

    app.Listen(":8098")
}
