#!/bin/bash

# TODO: yeah I know this is specific to ubuntu and its gonna sudo prompt, one day make it OS agnostic
sudo apt install -y protobuf-compiler

go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
