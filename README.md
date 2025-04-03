# GRPC Service Template
## A work in progress...

## Project Layout
[golang-standards/project-layout]https://github.com/golang-standards/project-layout
> It's not really a standard, but I like it.


## Three choices for grpc service communication
### Option 1 - insecure 
### Option 2 - server TLS, only the server implements TLS, client is anonymous but traffic is encrypted
### Option 3 - mutual TLS, the server and the client implements TLS, and the traffic encrypted

## Installed necessary components for GRPC
### described that in grpc-setup.sh

## I setup gen-protobuf.sh
### builds the protocol buffer go files into internal/protobuf