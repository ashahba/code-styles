#!/usr/bin/env bash
set +xe

CURR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Detect host and OS
HOST_OS=${HOST_OS:-$(uname | tr '[:upper:]' '[:lower:]')}
if [[ $(uname -m) == "x86_64" ]]; then
  HOST_ARCH="amd64"
else
  HOST_ARCH=${HOST_ARCH:-$(uname -m)}
fi

# Run everything within a virtural environment
VENV=${CURR_DIR}/.venv
virtualenv ${VENV}
. ${VENV}/bin/activate
pip install yapf flake8

# Download shfmt if it's not present
SHFMT_VER="v2.6.4"
if ! [ -x "$(command -v shfmt)" ]; then
  wget https://github.com/mvdan/sh/releases/download/${SHFMT_VER}/shfmt_${SHFMT_VER}_${HOST_OS}_${HOST_ARCH} -O ${VENV}/bin/shfmt
fi

TXT_FILES=$(find $(git ls-files) -type f -not -name ".gitignore" -not -name ".dockerignore" -not -name "*.ico" -not -name "*.jpg" -not -name "*.png" -not -name "*.bz2" -not -name "*tar" -not -name "*.tar.gz" -not -name "*.zip")

# clean trailing whitespaces. Please see this thread:
#   https://softwareengineering.stackexchange.com/questions/121555/why-is-trailing-whitespace-a-big-deal
for file in ${TXT_FILES}; do
  sed 's/[[:blank:]]*$//' ${file} > ${file}.new
  cat ${file}.new > ${file}
  rm -rf ${file}.new
done

# Check for consecutive empty lines within all text files
for file in ${TXT_FILES}; do
  cat -s ${file} > ${file}.new
  cat ${file}.new > ${file}
  rm -rf ${file}.new
done

# Fix styles for shell scripts
for file in $(find $(git ls-files) -name '*.sh'); do shfmt -i 2 -ci -l -w -sr $file; done

# Fix styles for python files
for file in $(find $(git ls-files) -name *.py); do yapf -i $file; done

# Check styles for python files
for file in $(find $(git ls-files) -name *.py); do flake8 $file; done

# Report style issues
if $(git diff --name-only); then
  echo "No style issues where found"
  exit 0
else
  echo "Some style issues where found:"
  echo $(git diff --name-only)
  exit 1
fi
set -xe
