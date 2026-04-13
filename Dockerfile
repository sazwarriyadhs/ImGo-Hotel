FROM golang:1.22

WORKDIR /app

# Copy go.mod dan go.sum dari folder backend
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# Copy seluruh folder backend
COPY backend/ .

# Build aplikasi
RUN go build -v -o app .

EXPOSE 8092 8093 8094 8095 8096 8097 8098

CMD ["./app"]