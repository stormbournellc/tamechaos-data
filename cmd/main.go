package main

import (
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

const (
	serverCertFile = "assets/certs/server-cert.pem"
	serverKeyFile  = "assets/certs/server-key.pem"
)

type server struct {
	//protobuf.Unimplemented[whatever]Server
}

// loadTLSCredentials loads the client
func loadTLSCredentials() (credentials.TransportCredentials, error) {
	// Load certificate of the CA who signed client's certificate
	//pemClientCA, err := os.ReadFile(clientCACertFile)
	//if err != nil {
	//	return nil, err
	//}

	//certPool := x509.NewCertPool()
	//if !certPool.AppendCertsFromPEM(pemClientCA) {
	//	return nil, fmt.Errorf("failed to add client CA's certificate")
	//}

	// Load server's certificate and private key
	serverCert, err := tls.LoadX509KeyPair(serverCertFile, serverKeyFile)
	if err != nil {
		return nil, err
	}

	// Create the credentials and return it
	config := &tls.Config{
		Certificates: []tls.Certificate{serverCert},
		//ClientAuth:   tls.RequireAndVerifyClientCert,
		//ClientCAs:    certPool,
	}

	return credentials.NewTLS(config), nil

}

// runServer will implement the grpc functions defined by the protocol buffer generation
func runServer(enableTLS bool, listener net.Listener) error {

	var serverOptions []grpc.ServerOption

	if enableTLS {
		tlsCredentials, err := loadTLSCredentials()
		if err != nil {
			return fmt.Errorf("cannot load TLS credentials: %w", err)
		}
		serverOptions = append(serverOptions, grpc.Creds(tlsCredentials))
	}

	log.Printf("Start GRPC server at %s, TLS = %t", listener.Addr().String(), enableTLS)
	return grpcServer.Serve(listener)
}

func main() {
	port := flag.Int("port", 0, "the port for this service")
	enableTLS := flag.Bool("tls", false, "enable SSL/TLS")
	flag.Parse()

	listener, err := net.Listen("tcp", fmt.Sprintf("0.0.0.0:%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	err = runServer(*enableTLS, listener)

}
