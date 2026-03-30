#!/usr/bin/env bash
# https://github.com/mozilla/grcov
cd $1
find ./ -type f -name "*.profraw" -exec rm -rf {} \;
cargo clean
