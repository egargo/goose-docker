# Goose Docker

A Docker image for [goose](https://github.com/pressly/goose).


## About

The goal of this image is to create an small and easy-to-use
Docker image for goose.


## Usage

Configure goose with the following variables in your `.env` file.

```env
GOOSE_DRIVER=postgres
GOOSE_DBSTRING=postgres://user:password@0.0.0.0:5432/db
GOOSE_MIGRATION_DIR=./migrations
```

Then add the following build stage in your `Dockerfile`.

```Dockerfile
FROM ghcr.io/egargo/goose-docker:3.26.0-postgres AS migrator
COPY ./migrations ./migrations
COPY ./.env ./.env
RUN goose up

# ...

FROM golang
COPY --from=migrator /.env .
# ...
```

Example `Dockerfile`:

```Dockerfile
FROM ghcr.io/egargo/goose-docker:3.26.0-postgres AS migrator
COPY ./migrations ./migrations
COPY ./env ./.env
RUN goose up

FROM golang:1.25.3-alpine3.22 AS builder
ENV GOPROXY=direct
WORKDIR /app
COPY . .
RUN apk --no-cache add git && \
	go mod download && \
	go build -o bin/api cmd/api/main.go

FROM scratch
WORKDIR /app
COPY --from=migrator /.env /app/.env
COPY --from=builder /app/api /app/api
EXPOSE 8000
CMD [ "/app/api" ]
```


## Credits

- [pressly/goose](https://github.com/pressly/goose/)
- [gomicro/docker-goose](https://github.com/gomicro/docker-goose)


## License

This program is provided under the [MIT License](./LICENSE).
