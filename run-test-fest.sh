#!/bin/bash

## run-test-fest.sh <major-number> <minor-number>
# Run a test fest for assignment <major-number>.<minor-number>

if [[ $1 == "" || $2 == "" ]]; then
    printf "Error: Invalid usage.\n"
    printf "Usage: run-test-fest.sh <major-number> <minor-number>\n"
    exit 1
fi

CWD=$(pwd)
ASSIGN_DIR="$CWD/Deliverables/$1/$1.$2"
ASSIGN_DIR_LOWER="$CWD/deliverables/$1/$1.$2"
# RACKET_PATH="/usr/racket/bin/racket"
RACKET_PATH="racket"

# Check directory structure
if [[ ! -d "$ASSIGN_DIR" && ! -d "$ASSIGN_DIR_LOWER" ]]; then
    printf "Error: Unable to locate deliverable folder at ${ASSIGN_DIR}.\n"
    printf "Is your directory structure correct?\n"
    exit 1
elif [[ -d "$ASSIGN_DIR_LOWER" ]]; then
    ASSIGN_DIR="$ASSIGN_DIR_LOWER"
fi

EXE_PATH="${ASSIGN_DIR}/run"

# Try to build exe
pushd "$ASSIGN_DIR"
make
popd

# Check exe
if [[ ! -f "$EXE_PATH" ]]; then
    printf "Error: makefile failed to build an executable,.\n"
    printf "or it isn't called `run`.\n"
    exit 1
fi

# Setup environment
# git clone https://github.com/greghendershott/travis-racket.git
# cat travis-racket/install-racket.sh | bash # pipe to bash not sh!

export PLTSTDERR="debug@fest"
cd oracle && $RACKET_PATH test-fest/test-fest.rkt -M $1 -m $2 -t "$EXE_PATH"
