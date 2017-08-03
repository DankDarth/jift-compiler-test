#!/bin/bash

if [ "$1" = "clean" ]; then
	rm -r src/nimcache
	rm target/jiftc
else
	nim -o:target/jiftc --opt:none c src/main.nim
fi
