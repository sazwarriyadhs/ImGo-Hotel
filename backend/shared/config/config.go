// C:\imgo-enterprise\backend\shared\config\config.go
package config

import (
	"os"
	"strconv"
)

type Config struct {
	// Database
	DBHost     string
	DBPort     string
	DBUser     string
	DBPassword string
	DBName     string

	// Service Ports
	APIGatewayPort     int
	AuthServicePort    int
	HotelServicePort   int
	RestaurantPort     int
	SpaServicePort     int
	PilatesServicePort int
	AIServicePort      int
	PromoServicePort   int
	EmployeeServicePort int

	// JWT
	JWTSecret string

	// Environment
	GoEnv string
}

var AppConfig *Config

func LoadConfig() *Config {
	AppConfig = &Config{
		// Database
		DBHost:     getEnv("DB_HOST", "localhost"),
		DBPort:     getEnv("DB_PORT", "5432"),
		DBUser:     getEnv("DB_USER", "postgres"),
		DBPassword: getEnv("DB_PASSWORD", "newpassword123"),
		DBName:     getEnv("DB_NAME", "imgohotel"),

		// Service Ports
		APIGatewayPort:     getEnvInt("API_GATEWAY_PORT", 8092),
		AuthServicePort:    getEnvInt("AUTH_SERVICE_PORT", 8093),
		HotelServicePort:   getEnvInt("HOTEL_SERVICE_PORT", 8094),
		RestaurantPort:     getEnvInt("RESTAURANT_SERVICE_PORT", 8095),
		SpaServicePort:     getEnvInt("SPA_SERVICE_PORT", 8096),
		PilatesServicePort: getEnvInt("PILATES_SERVICE_PORT", 8097),
		AIServicePort:      getEnvInt("AI_SERVICE_PORT", 8098),
		PromoServicePort:   getEnvInt("PROMO_SERVICE_PORT", 8099),
		EmployeeServicePort: getEnvInt("EMPLOYEE_SERVICE_PORT", 8100),

		// JWT
		JWTSecret: getEnv("JWT_SECRET", "imgo-super-secret-key-2026"),

		// Environment
		GoEnv: getEnv("GO_ENV", "development"),
	}
	return AppConfig
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intVal, err := strconv.Atoi(value); err == nil {
			return intVal
		}
	}
	return defaultValue
}

func IsDevelopment() bool {
	return AppConfig != nil && AppConfig.GoEnv == "development"
}

func IsProduction() bool {
	return AppConfig != nil && AppConfig.GoEnv == "production"
}

func GetServiceURL(servicePort int) string {
	if IsDevelopment() {
		return "http://localhost:" + strconv.Itoa(servicePort)
	}
	return "http://" + getEnv("SERVICE_HOST", "localhost") + ":" + strconv.Itoa(servicePort)
}