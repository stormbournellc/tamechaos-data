#!/bin/bash

# you can comment these out if you've run this before, if you leave it in
# it should make sure you are running latest generators when you regen your
# proto file
#
# you need the protobuf compiler
# sudo apt install protobuf-compiler
#
# install the core protocol buffer support
#go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#i install the grpc extensions for proto buf
#go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


protoc --go_out=pkg/protobuf --go_opt=paths=source_relative \
    --go-grpc_out=pkg/protobuf --go-grpc_opt=paths=source_relative \
    --proto_path=proto/ proto/app.proto

