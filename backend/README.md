Here's a comprehensive README.md for your backend project:

# FundFlow Backend

A robust Go-based backend service for managing personal finances, featuring user authentication, bank account management, transaction tracking, and category-based expense management.

## Features

- **User Management**
  - Registration and Authentication
  - JWT-based authorization
  - Profile management
  - Password reset with OTP verification

- **Bank Account Management**
  - Multiple bank account support
  - Bank balance tracking
  - Inter-bank transfers

- **Transaction Management**
  - Income and expense tracking
  - Transaction categorization
  - Transaction history

- **Category Management**
  - Custom expense categories
  - Category-based budgeting
  - Category-wise transaction tracking

## Tech Stack

- **Language**: Go 1.22
- **Framework**: Gin (Web Framework)
- **Database**: PostgreSQL
- **ORM**: GORM
- **Authentication**: JWT
- **Email Service**: Mailjet

## Prerequisites

- Go 1.22 or higher
- Docker and Docker Compose
- PostgreSQL
- Make (optional)

## Getting Started

1. Clone the repository

2. Install dependencies:
```bash
go mod tidy
```

3. Set up environment variables:
   - Rename `.env-test` to `.env`
   - Configure the following variables:
   ```
   DB_HOST=localhost
   DB_USER=postgres
   DB_PASSWORD=postgres
   DB_NAME=fundflow_db
   DB_PORT=5432
   DB_SSLMODE=disable
   JWT_SECRET=your_jwt_secret
   MAILJET_API_KEY=your_mailjet_api_key
   MAILJET_SECRET_KEY=your_mailjet_secret_key
   ```

4. Run with Docker:
```bash
docker compose up --build
```

## API Endpoints

### Authentication
- `POST /register` - Register new user
- `POST /login` - User login
- `POST /claim-otp` - Request OTP for password reset
- `POST /verify-otp` - Verify OTP
- `POST /reset-password` - Reset password

### Profile Management
- `GET /profile` - Get user profile
- `PUT /profile` - Update user profile

### Settings
- `POST /settings/change-email` - Change email
- `POST /settings/change-password` - Change password
- `DELETE /settings/delete-account` - Delete account

### Bank Management
- `GET /banks/all` - Get all banks
- `GET /banks/:id` - Get specific bank
- `POST /banks/create` - Create new bank
- `PUT /banks/:bank_id` - Update bank
- `DELETE /banks/:bank_id` - Delete bank
- `POST /banks/transfer` - Transfer between banks

### Transactions
- `GET /transactions/all` - Get all transactions
- `GET /transactions/:id` - Get specific transaction
- `POST /transactions/create` - Create transaction
- `PUT /transactions/:transaction_id` - Update transaction
- `DELETE /transactions/:transaction_id` - Delete transaction

### Categories
- `GET /categories/all` - Get all categories
- `GET /categories/:category_id` - Get specific category
- `POST /categories/create` - Create category
- `PUT /categories/:category_id` - Update category
- `DELETE /categories/:category_id` - Delete category

## Project Structure

```
.
├── cmd/
│   └── app/
│       └── main.go
├── pkg/
│   ├── config/
│   ├── handlers/
│   ├── middleware/
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── utils/
├── docker-compose.yml
├── Dockerfile
└── go.mod
```

## Security Features

- Password hashing using bcrypt
- JWT-based authentication
- OTP verification for password reset
- Request validation and sanitization
- CORS protection
- Database transaction management

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License.