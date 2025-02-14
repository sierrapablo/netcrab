FROM rust:latest AS builder
WORKDIR /app

COPY Cargo.toml ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true

COPY . .
RUN cargo build --release

FROM debian:latest
WORKDIR /app
COPY --from=builder /app/target/release/netcrab ./

RUN apt update && apt install -y iputils-ping iperf3

RUN mkdir -p /app/logs
VOLUME ["/app/logs"]

CMD ["./netcrab"]
