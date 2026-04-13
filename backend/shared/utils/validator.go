// C:\imgo-enterprise\backend\shared\utils\validator.go
package utils

import (
	"regexp"
	"strings"
)

func ValidateEmail(email string) bool {
	emailRegex := regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$`)
	return emailRegex.MatchString(strings.ToLower(email))
}

func ValidatePhone(phone string) bool {
	phoneRegex := regexp.MustCompile(`^[0-9]{10,13}$`)
	return phoneRegex.MatchString(phone)
}

func ValidatePassword(password string) bool {
	// At least 8 characters
	if len(password) < 8 {
		return false
	}
	
	// Contains at least one digit
	hasDigit := regexp.MustCompile(`[0-9]`).MatchString(password)
	if !hasDigit {
		return false
	}
	
	// Contains at least one uppercase letter
	hasUpper := regexp.MustCompile(`[A-Z]`).MatchString(password)
	if !hasUpper {
		return false
	}
	
	// Contains at least one lowercase letter
	hasLower := regexp.MustCompile(`[a-z]`).MatchString(password)
	
	return hasLower
}

func IsEmptyString(s string) bool {
	return strings.TrimSpace(s) == ""
}

func TruncateString(s string, maxLength int) string {
	if len(s) <= maxLength {
		return s
	}
	return s[:maxLength] + "..."
}