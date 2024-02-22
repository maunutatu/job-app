FROM golang:1.22.0-alpine as builder

WORKDIR /server

COPY go.mod go.sum ./
RUN go mod download

COPY api ./api
COPY database ./database
COPY main.go ./

RUN CGO_ENABLED=0 go build -o server ./main.go

FROM alpine:3.16.2

WORKDIR /server

COPY --from=builder /server/server /server/server

EXPOSE 8080

ENV GIN_MODE=release

CMD ["./server"]