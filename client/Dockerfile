# syntax=docker/dockerfile:1
FROM golang:1.16-alpine as builder
RUN apk add git
WORKDIR /go/src/app
COPY ../. /go/src/app

RUN --mount=type=cache,target=/go/pkg/mod/ \
    go get -d -v ./...
RUN --mount=type=cache,target=/go/pkg/mod/ \
    go install -v ./...

FROM alpine
COPY --from=builder /go/bin/* /usr/local/bin/

EXPOSE 5001
EXPOSE 5002

CMD ["client"]
