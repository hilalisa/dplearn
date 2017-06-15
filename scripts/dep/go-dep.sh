#!/usr/bin/env bash
set -e

if ! [[ "$0" =~ "./scripts/dep/go-dep.sh" ]]; then
  echo "must be run from repository root"
  exit 255
fi

rm -rf ./vendor
rm -rf ./vendor.orig

echo "Updating Go dependencies"
DEP_ROOT="$GOPATH/src/github.com/golang/dep"
go get -d -u github.com/golang/dep
pushd "${DEP_ROOT}"
  git reset --hard HEAD
  go install -v ./cmd/dep
popd

if [ ! $(command -v dep) ]; then
  echo "dep: command not found"
  exit 1
fi

dep ensure -update -v

# TODO: this removes all deps for other archs
# dep prune -v

