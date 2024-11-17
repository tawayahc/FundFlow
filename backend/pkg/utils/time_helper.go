package utils

import (
	"errors"
	"time"
)

// ParseCreatedAt parses the created_at date and time from the given date and time strings.
func ParseCreatedAt(date, timeStr string) (time.Time, error) {
	var createdAt time.Time
	var err error

	if timeStr != "" {
		createdAt, err = time.Parse("2006-01-02 15:04:05", date+" "+timeStr)
	} else {
		createdAt, err = time.Parse("2006-01-02", date)
	}
	if err != nil {
		return time.Time{}, errors.New("invalid created_at date and time")
	}

	return createdAt, nil
}
