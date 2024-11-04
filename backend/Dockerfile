# Build Stage
FROM golang:1.22 AS builder

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application for Linux (Alpine) environment
RUN GOOS=linux GOARCH=amd64 go build -o main cmd/app/main.go

# Run Stage
FROM alpine:latest

WORKDIR /root/

# Install necessary dependencies
RUN apk --no-cache add ca-certificates

# Copy the binary and .env file from the build stage
COPY --from=builder /app/main .
COPY --from=builder /app/.env .env

# Ensure the binary is executable
RUN chmod +x ./main

# Expose the application port (if needed)
EXPOSE 8080

# Start the application
CMD ["./main"]