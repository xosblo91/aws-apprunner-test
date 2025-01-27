# 1) Build stage
# Use the official Go image to compile your application
FROM golang:1.20 AS builder

# Create and set the working directory
WORKDIR /app

# Copy the Go mod files and download dependencies first (caching optimization)
COPY go.mod go.sum ./
RUN go mod download

ARG BUILD_VERSION=0
ENV BUILD_VERSION=$BUILD_VERSION

# Now copy the entire source
COPY . .

# Build the binary for Linux (amd64)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /hello-world

# 2) Final stage
# Use a minimal base image (alpine or distroless) to reduce the image size
FROM alpine:latest

# Create a working directory
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /hello-world /app/

# Expose port 8080 to the outside world
EXPOSE 8080

# Define the command to run your service
CMD ["./hello-world"]
