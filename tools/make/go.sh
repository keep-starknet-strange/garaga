#!/bin/bash

cd ./tools/parser_go
go build main.go
cd ./bls12_381/cairo_test
go build main.go