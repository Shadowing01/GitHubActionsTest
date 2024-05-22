FROM golang:alpine
COPY httpenv.go /go
RUN go build httpenv.go

FROM alpine as base
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=0 --chown=httpenv:httpenv /go/httpenv /httpenv
EXPOSE 8888

#########################
FROM base as test

#layer test tools and assets on top as optional test stage
RUN apk add --no-cache apache2-utils

#########################
FROM base as final

# we're not changing user in this example, but you could:
# USER httpenv
CMD ["/httpenv"]