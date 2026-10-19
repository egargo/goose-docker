FROM alpine AS mini

ARG version=3.26.0

ADD https://github.com/pressly/goose/releases/download/v${version}/goose_linux_x86_64 ./goose

RUN  chmod +x ./goose && \
	apk add --no-cache upx && \
	upx --best --lzma ./goose



FROM alpine

LABEL maintainer="egargo <https://github.com/egargo>"

COPY --from=mini /goose /bin/goose

ENTRYPOINT [ "goose" ]
