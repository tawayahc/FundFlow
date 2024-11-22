package services

import (
	"errors"
	"testing"

	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/services"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type MockDB struct {
	mock.Mock
	*gorm.DB
}

func (m *MockDB) Begin() *gorm.DB {
	args := m.Called()
	return args.Get(0).(*gorm.DB)
}

func (m *MockDB) Create(value interface{}) *gorm.DB {
	args := m.Called(value)
	return args.Get(0).(*gorm.DB)
}

func (m *MockDB) Rollback() *gorm.DB {
	args := m.Called()
	return args.Get(0).(*gorm.DB)
}

func (m *MockDB) Commit() *gorm.DB {
	args := m.Called()
	return args.Get(0).(*gorm.DB)
}

func TestCreateUser(t *testing.T) {
	// Use an in-memory SQLite DB to initialize *gorm.DB
	db, _ := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	mockDB := &MockDB{DB: db}
	config.DB = mockDB.DB

	tests := []struct {
		name          string
		creds         models.Registration
		mockSetup     func()
		expectedError error
	}{
		{
			name: "Successful user creation",
			creds: models.Registration{
				Username: "testuser",
				Password: "password",
				Email:    "test@example.com",
			},
			mockSetup: func() {
				mockDB.On("Begin").Return(mockDB.DB.Begin()).Once()
				mockDB.On("Create", mock.Anything).Return(mockDB.DB.Create(&models.Authentication{})).Once()
				mockDB.On("Commit").Return(mockDB.DB.Commit()).Once()
			},
			expectedError: nil,
		},
		{
			name: "Username already exists",
			creds: models.Registration{
				Username: "existinguser",
				Password: "password",
				Email:    "test@example.com",
			},
			mockSetup: func() {
				mockDB.On("Begin").Return(mockDB.DB.Begin()).Once()
				mockDB.On("Create", mock.Anything).Return(&gorm.DB{Error: errors.New("username already exists")}).Once()
				mockDB.On("Rollback").Return(mockDB.DB.Rollback()).Once()
			},
			expectedError: errors.New("username already exists"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockSetup()
			err := services.CreateUser(tt.creds) // Ensure CreateUser is implemented in services package
			assert.Equal(t, tt.expectedError, err)
			mockDB.AssertExpectations(t)
		})
	}
}
