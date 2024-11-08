package models

import "gorm.io/gorm"

type Book struct {
	gorm.Model
	Title       string `json:"title"`
	Author      string `json:"author"`
	Description string `json:"description"`
	PublishedAt string `json:"published_at"`
}
