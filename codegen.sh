#!/bin/bash
swift build -c release && cp -f .build/release/codegen /usr/local/bin
echo "$@"
exit 0