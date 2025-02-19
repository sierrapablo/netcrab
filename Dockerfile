# Image for building the project
FROM rust:latest AS builder
WORKDIR /app

# Copy the Cargo.toml and Cargo.lock files and build the project
COPY Cargo.toml ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true

COPY . .
RUN cargo build --release

# Image for running the project
FROM debian:latest
WORKDIR /app
COPY --from=builder /app/target/release/netcrab ./

# Install iputils-ping and iperf3
RUN apt update && apt install -y iputils-ping iperf3

# Create a directory for logs and make it a volume
RUN mkdir -p /app/logs
VOLUME ["/app/logs"]

# Run the project
CMD ["./netcrab"]
