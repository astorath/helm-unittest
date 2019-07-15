FROM golang:1.12-alpine as ALPINE-BUILDER
RUN apk --no-cache add --quiet alpine-sdk=1.0-r0

ENV GO111MODULE=on

WORKDIR /go/src/gitlab.3adigital.ru/gitlab-ci/helm-unittest/
COPY go.mod go.sum Makefile ./
RUN make deps

COPY . .
RUN install -d /opt && make install HELM_PLUGIN_DIR=/opt

FROM alpine:3.9 as ALPINE
COPY --from=ALPINE-BUILDER /opt /opt
RUN /opt/helm-unittest --help
