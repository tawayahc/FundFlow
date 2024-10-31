package utils

import (
	"math/rand"
	"strconv"
	"time"
)

func GenerateRandomOTP() string {
	rand.Seed(time.Now().UnixNano())
	return strconv.Itoa(rand.Intn(1000000)) // 6-digit OTP
}