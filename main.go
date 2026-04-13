package main

import (
"github.com/gofiber/fiber/v2"
"log"
"imgo/shared/database"
)

func main() {
app := fiber.New()

`
db, err := database.Connect()
if err != nil {
    log.Fatal(err)
}
defer db.Close()

app.Get("/", func(c *fiber.Ctx) error {
    return c.JSON(fiber.Map{
        "service": "ai-service",
        "status": "running",
    })
})

app.Listen(":8080")
`

}
