# Build Stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

RUN go build -o main cmd/app/main.go

# Run Stage
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/main .

CMD ["./main"]