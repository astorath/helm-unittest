
# borrowed from https://github.com/technosophos/helm-template

HELM_HOME ?= $(shell helm home)
HELM_PLUGIN_DIR ?= $(HELM_HOME)/plugins/helm-unittest
VERSION := $(shell sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' plugin.yaml)
GIT_VERSION ?= $(CIRCLE_TAG)
DIST := $(CURDIR)/_dist
LDFLAGS := "-X 'main.version=${VERSION}' -extldflags '-static'"
DOCKER ?= "irills/helm-unittest"

.PHONY: install
install: build test
	cp helm-unittest $(HELM_PLUGIN_DIR)
	cp plugin.yaml $(HELM_PLUGIN_DIR)

.PHONY: hookInstall
hookInstall: build

.PHONY: build
build:
	go build -o helm-unittest -ldflags $(LDFLAGS) ./main.go

.PHONY: test
test:
	go test -v -ldflags $(LDFLAGS) ./unittest/

.PHONY: check
check:
gofmt := $(shell gofmt -l . 2>&1)
ifneq ($(strip $(gofmt)),)
$(error gofmt have found errors in $(gofmt))
endif
ifneq ($(strip $(GIT_VERSION)),)
ifneq "$(VERSION)" "$(GIT_VERSION:v%=%)"
$(error Plugin yaml version [v$(VERSION)] does not match git tag version [$(GIT_VERSION)])
endif
endif

.PHONY: dist
dist: check
	mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o helm-unittest -ldflags $(LDFLAGS) ./main.go
	tar -zcvf $(DIST)/helm-unittest-linux-$(VERSION).tgz helm-unittest README.md LICENSE plugin.yaml
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o helm-unittest -ldflags $(LDFLAGS) ./main.go
	tar -zcvf $(DIST)/helm-unittest-macos-$(VERSION).tgz helm-unittest README.md LICENSE plugin.yaml
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o helm-unittest.exe -ldflags $(LDFLAGS) ./main.go
	tar -zcvf $(DIST)/helm-unittest-windows-$(VERSION).tgz helm-unittest.exe README.md LICENSE plugin.yaml

.PHONY: dockerimage
dockerimage:
	docker build -t $(DOCKER):$(VERSION) .

.PHONY: deps
deps:
	go mod download
