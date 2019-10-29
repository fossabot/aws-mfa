.PHONY: check clean test build package package-snapshot docs

export GO111MODULE=on

TAG_NAME := $(shell git tag -l --contains HEAD)
SHA := $(shell git rev-parse HEAD)
VERSION := $(if $(TAG_NAME),$(TAG_NAME),$(SHA))
DATE := $(shell date +'%Y-%m-%d %H:%M:%S')

default: check test build

test:
	go test -v -cover ./...

clean:
	rm -rf dist/

build: clean
	@echo Version: $(VERSION)
	go build -v -ldflags '-X "main.Version=${VERSION}" -X "main.ShortCommit=${SHA}" -X "main.Date=${DATE}"' .

check:
	golangci-lint run

doc:
	go run . doc

package:
	goreleaser --skip-publish --skip-validate --rm-dist

package-snapshot:
	goreleaser --skip-publish --skip-validate --rm-dist --snapshot
