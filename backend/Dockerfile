# Build Stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

# Build the Go application
RUN go build -o main cmd/app/main.go

# Run Stage
FROM alpine:latest

WORKDIR /root/

# Copy the binary from the build stage
COPY --from=builder /app/main .

# Copy the .env file to the final stage
COPY --from=builder /app/.env .env

# Ensure the .env file is available to the binary
CMD ["./main"]