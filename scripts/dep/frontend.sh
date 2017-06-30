#!/usr/bin/env bash
set -e

if ! [[ "$0" =~ "./scripts/dep/frontend.sh" ]]; then
  echo "must be run from repository root"
  exit 255
fi

<<COMMENT
SKIP_REBUILD=1 ./scripts/dep/frontend.sh
COMMENT

source ${NVM_DIR}/nvm.sh
nvm install v8.1.3

go install -v ./cmd/gen-package-json
gen-package-json --output package.json --logtostderr

echo "Updating frontend dependencies with 'yarn' and 'npm'..."
rm -f ./package-lock.json
yarn install
if [[ "${SKIP_REBUILD}" ]]; then
  echo "SKIP_REBUILD is defined"
else
  echo "SKIP_REBUILD is not defined"
  npm rebuild node-sass --force
fi
yarn install
npm install
# npm install -g tslint

nvm install v8.1.3
nvm alias default 8.1.3
nvm alias default node
which node
node -v
